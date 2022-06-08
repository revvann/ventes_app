import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/product_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/data_sources/product_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/product_fu_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductFormUpdateListener {
  ProductFormUpdateFormSource get _formSource => Get.find<ProductFormUpdateFormSource>();
  ProductFormUpdateProperties get _properties => Get.find<ProductFormUpdateProperties>();
  ProductFormUpdateDataSource get _dataSource => Get.find<ProductFormUpdateDataSource>();

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  void onSubmitButtonClicked() {
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      _dataSource.updateData(_properties.productid, data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateProductTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formUpdateProductTaskCode, "Please fill all required fields");
    }
  }

  void onTaxChanged(item) {
    _formSource.prosproducttax = item.value;
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formUpdateProductTaskCode, message, () {
      Get.find<ProductStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }
}
