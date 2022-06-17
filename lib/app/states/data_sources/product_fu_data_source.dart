// ignore_for_file: prefer_final_fields

part of 'package:ventes/app/states/controllers/product_fu_state_controller.dart';

class ProductFormUpdateDataSource extends StateDataSource<ProductFormUpdatePresenter> implements ProductUpdateContract {
  ProductFormUpdateListener get _listener => Get.find<ProductFormUpdateListener>(tag: ProspectString.productUpdateTag);
  ProductFormUpdateFormSource get _formSource => Get.find<ProductFormUpdateFormSource>(tag: ProspectString.productUpdateTag);
  ProductFormUpdateProperty get _properties => Get.find<ProductFormUpdateProperty>(tag: ProspectString.productUpdateTag);

  final _product = Rx<ProspectProduct?>(null);
  set product(ProspectProduct? value) => _product.value = value;
  ProspectProduct? get product => _product.value;

  final _taxItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set taxItems(List<KeyableDropdownItem<int, DBType>> value) => _taxItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get taxItems => _taxItems.value;

  void fetchData(int id) => presenter.fetchData(id);
  void updateData(int id, Map<String, dynamic> data) => presenter.updateProduct(id, data);

  @override
  ProductFormUpdatePresenter presenterBuilder() => ProductFormUpdatePresenter();

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['product'] != null) {
      product = ProspectProduct.fromJson(data['product']);
      _formSource.prepareFormValues();
    }

    if (data['taxes'] != null) {
      List<DBType> taxes = data['taxes'].map<DBType>((tax) => DBType.fromJson(tax)).toList();
      taxItems = taxes.map<KeyableDropdownItem<int, DBType>>((tax) => KeyableDropdownItem<int, DBType>(key: tax.typeid!, value: tax)).toList();
    }

    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
