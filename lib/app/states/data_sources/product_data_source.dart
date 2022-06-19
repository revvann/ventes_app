import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/product_presenter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductDataSource extends StateDataSource<ProductPresenter> implements ProductContract {
  Listener get _listener => Get.find<Listener>(tag: ProspectString.productTag);
  Property get _property => Get.find<Property>(tag: ProspectString.productTag);

  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? prospect) => _prospect.value = prospect;

  final _products = Rx<List<ProspectProduct>>([]);
  List<ProspectProduct> get products => _products.value;
  set products(List<ProspectProduct> products) => _products.value = products;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);
  void fetchProducts(int productid, String search) => presenter.fetchProducts(productid, search);
  void deleteProduct(int productid) => presenter.deleteProduct(productid);

  @override
  ProductPresenter presenterBuilder() => ProductPresenter();

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

    Get.find<TaskHelper>().loaderPop(_property.task.name);
    _property.isLoading.value = false;
  }

  @override
  void onDeleteError(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => _listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => _listener.onDeleteSuccess(message);
}
