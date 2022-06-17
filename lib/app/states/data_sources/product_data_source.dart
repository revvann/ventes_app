part of 'package:ventes/app/states/controllers/product_state_controller.dart';

class ProductDataSource extends StateDataSource<ProductPresenter> implements ProductContract {
  ProductListener get _listener => Get.find<ProductListener>(tag: ProspectString.productTag);
  ProductProperty get _properties => Get.find<ProductProperty>(tag: ProspectString.productTag);

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

    Get.find<TaskHelper>().loaderPop(_properties.task.name);
    _properties.isLoading.value = false;
  }

  @override
  void onDeleteError(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => _listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => _listener.onDeleteSuccess(message);
}
