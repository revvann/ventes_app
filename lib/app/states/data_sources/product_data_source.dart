import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/product_presenter.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/listeners/product_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductDataSource implements FetchDataContract {
  ProductListener get _listener => Get.find<ProductListener>();
  ProductProperties get _properties => Get.find<ProductProperties>();

  final ProductPresenter _presenter = ProductPresenter();

  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? prospect) => _prospect.value = prospect;

  final _products = Rx<List<ProspectProduct>>([]);
  List<ProspectProduct> get products => _products.value;
  set products(List<ProspectProduct> products) => _products.value = products;

  init() {
    _presenter.fetchContract = this;
  }

  void fetchData(int prospectid) => _presenter.fetchData(prospectid);
  void fetchProducts(int productid, String search) => _presenter.fetchProducts(productid, search);

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectproducts'] != null) {
      products = data['prospectproducts'].map<ProspectProduct>((e) => ProspectProduct.fromJson(e)).toList();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
    _properties.isLoading.value = false;
  }
}
