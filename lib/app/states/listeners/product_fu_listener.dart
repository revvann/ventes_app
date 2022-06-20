import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductFormUpdateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.updateProductConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onTaxChanged(item) {
    formSource.prosproducttax = item.value;
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProductStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.refresh();
  }
}
