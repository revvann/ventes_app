import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/resources/views/product_form/update/product_fu.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ProspectString.productTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.productTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void navigateToFormEdit(int id) {
    Get.toNamed(
      ProductFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        "product": id,
      },
    );
  }

  void deleteProduct(int productid) {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.deleteProductConfirm,
        onFinished: (res) {
          if (res) {
            _dataSource.deleteProduct(productid);
            Get.find<TaskHelper>().loaderPush(_property.task);
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
    _property.isLoading.value = false;
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
    _property.isLoading.value = false;
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProductStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
