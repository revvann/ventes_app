import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/properties/nearby_property.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';

class CustomerFormUpdateListener extends StateListener {
  Property get _property => Get.find<Property>(tag: NearbyString.customerUpdateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: NearbyString.customerUpdateTag);

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }

  void onTypeSelected(int type) {
    _formSource.cstmtypeid = type;
  }

  void onMapControllerUpdated(GoogleMapController controller) {
    if (!_property.mapsController.isCompleted) {
      _property.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    _property.markerLatLng = position.target;
    _formSource.cstmlatitude = position.target.latitude.toString();
    _formSource.cstmlongitude = position.target.longitude.toString();
  }

  void onCameraMoveEnd() {
    _property.cameraMoveType = CameraMoveType.dragged;
  }

  void onPicturePicked() async {
    ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _formSource.picture = File(image.path);
      _formSource.defaultPicture.value = Image.file(_formSource.picture!);
    }
  }

  void onStatusSelected(int status) {
    _formSource.sbccstmstatusid = status;
  }

  void onSubmitButtonClicked() async {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: NearbyString.updateCustomerConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    _property.refresh();
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataSuccess(String message) async {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().property.refresh();
          Get.back(id: NearbyNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }
}
