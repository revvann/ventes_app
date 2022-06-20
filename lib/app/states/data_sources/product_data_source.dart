import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/product_presenter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/states/typedefs/product_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductDataSource extends StateDataSource<ProductPresenter> with DataSourceMixin implements ProductContract {
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
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectproducts'] != null) {
      products = data['prospectproducts'].map<ProspectProduct>((e) => ProspectProduct.fromJson(e)).toList();
    }

    Get.find<TaskHelper>().loaderPop(property.task.name);
    property.isLoading.value = false;
  }

  @override
  void onDeleteError(String message) => listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => listener.onDeleteSuccess(message);

  @override
  void onDeleteComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
