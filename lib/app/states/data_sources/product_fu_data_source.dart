// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/product_fu_presenter.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormUpdateDataSource extends StateDataSource<ProductFormUpdatePresenter> with DataSourceMixin implements ProductUpdateContract {
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
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['product'] != null) {
      product = ProspectProduct.fromJson(data['product']);
      formSource.prepareFormValues();
    }

    if (data['taxes'] != null) {
      List<DBType> taxes = data['taxes'].map<DBType>((tax) => DBType.fromJson(tax)).toList();
      taxItems = taxes.map<KeyableDropdownItem<int, DBType>>((tax) => KeyableDropdownItem<int, DBType>(key: tax.typeid!, value: tax)).toList();
    }

    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  void onUpdateError(String message) => listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => listener.onUpdateDataSuccess(message);

  @override
  onLoadComplete() => listener.onComplete();

  @override
  void onUpdateComplete() => listener.onComplete();
}
