import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductFormUpdateListener extends StateListener {
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.productUpdateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.productUpdateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.updateProductConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onTaxChanged(item) {
    _formSource.prosproducttax = item.value;
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProductStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
