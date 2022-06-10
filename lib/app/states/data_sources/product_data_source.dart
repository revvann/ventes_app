part of 'package:ventes/app/states/controllers/product_state_controller.dart';

class _DataSource extends RegularDataSource<ProductPresenter> implements FetchDataContract {
  _Listener get _listener => Get.find<_Listener>(tag: ProspectString.productTag);
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.productTag);

  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? prospect) => _prospect.value = prospect;

  final _products = Rx<List<ProspectProduct>>([]);
  List<ProspectProduct> get products => _products.value;
  set products(List<ProspectProduct> products) => _products.value = products;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);
  void fetchProducts(int productid, String search) => presenter.fetchProducts(productid, search);

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

    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
    _properties.isLoading.value = false;
  }
}
