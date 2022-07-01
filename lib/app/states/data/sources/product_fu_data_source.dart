// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/product_fu_presenter.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormUpdateDataSource extends StateDataSource<ProductFormUpdatePresenter> with DataSourceMixin {
  final String productID = 'producthdr';
  final String taxesID = 'taxhdr';
  final String updateID = 'updthdr';

  late DataHandler<ProspectProduct?, Map<String, dynamic>, Function(int)> productHandler;
  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> taxesHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> updateHandler;

  ProspectProduct? get product => productHandler.value;
  List<KeyableDropdownItem<int, DBType>> get taxItems => taxesHandler.value;

  List<KeyableDropdownItem<int, DBType>> _taxesSuccess(data) {
    List<DBType> taxes = data.map<DBType>((tax) => DBType.fromJson(tax)).toList();
    return taxes.map<KeyableDropdownItem<int, DBType>>((tax) => KeyableDropdownItem<int, DBType>(key: tax.typeid!, value: tax)).toList();
  }

  void _updateSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: message,
        onFinished: (res) {
          Get.find<ProductStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    productHandler = createDataHandler(productID, presenter.fetchProduct, null, ProspectProduct.fromJson, onComplete: () => formSource.prepareFormValues());
    taxesHandler = createDataHandler(taxesID, presenter.fetchTaxes, [], _taxesSuccess);
    updateHandler = DataHandler(
      updateID,
      fetcher: presenter.update,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(updateID)),
      onSuccess: _updateSuccess,
      onFailed: (message) => showFailed(updateID, message, false),
      onError: (message) => showError(updateID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(updateID),
    );
  }

  @override
  ProductFormUpdatePresenter presenterBuilder() => ProductFormUpdatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onUpdateError(String message) {}

  @override
  void onUpdateFailed(String message) {}

  @override
  void onUpdateSuccess(String message) {}

  @override
  onLoadComplete() {}

  @override
  void onUpdateComplete() {}
}
