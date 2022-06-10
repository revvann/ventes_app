// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/presenters/product_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_sources/product_fu_form_source.dart';
import 'package:ventes/app/states/listeners/product_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormUpdateDataSource implements FetchDataContract, UpdateContract {
  ProductFormUpdateListener get _listener => Get.find<ProductFormUpdateListener>();
  ProductFormUpdateFormSource get _formSource => Get.find<ProductFormUpdateFormSource>();

  ProductFormUpdatePresenter _presenter = ProductFormUpdatePresenter();

  final _product = Rx<ProspectProduct?>(null);
  set product(ProspectProduct? value) => _product.value = value;
  ProspectProduct? get product => _product.value;

  final _taxItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set taxItems(List<KeyableDropdownItem<int, DBType>> value) => _taxItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get taxItems => _taxItems.value;

  void init() {
    _presenter.fetchDataContract = this;
    _presenter.updateContract = this;
  }

  void fetchData(int id) => _presenter.fetchData(id);
  void updateData(int id, Map<String, dynamic> data) => _presenter.updateProduct(id, data);

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['product'] != null) {
      product = ProspectProduct.fromJson(data['product']);
      _formSource.prepareFormValue(product!);
    }

    if (data['taxes'] != null) {
      List<DBType> taxes = data['taxes'].map<DBType>((tax) => DBType.fromJson(tax)).toList();
      taxItems = taxes.map<KeyableDropdownItem<int, DBType>>((tax) => KeyableDropdownItem<int, DBType>(key: tax.typeid!, value: tax)).toList();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
