import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailFormCreateListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ProspectString.detailCreateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.detailCreateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onDateSelected(DateTime? date) {
    _formSource.date = date;
  }

  void onCategorySelected(category) {
    _formSource.prosdtcategory = category.value;
  }

  void onTypeSelected(type) {
    _formSource.prosdttype = type.value;
  }

  void onMapControllerCreated(GoogleMapController? controller) {
    if (!_property.mapsController.isCompleted) {
      _property.mapsController.complete(controller);
    }
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.createDetailConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProspectDetailStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
