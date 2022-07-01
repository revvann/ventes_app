import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/states/properties/nearby_property.dart';
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class CustomerFormUpdateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.nearby.index);
  }

  void onTypeSelected(int type) {
    formSource.cstmtypeid = type;
  }

  void onMapControllerUpdated(GoogleMapController controller) {
    if (!property.mapsController.isCompleted) {
      property.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    property.markerLatLng = position.target;
    formSource.cstmlatitude = position.target.latitude.toString();
    formSource.cstmlongitude = position.target.longitude.toString();
  }

  void onCameraMoveEnd() {
    property.cameraMoveType = CameraMoveType.dragged;
  }

  void onPicturePicked() async {
    ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      formSource.picture = File(image.path);
      formSource.defaultPicture.value = Image.file(formSource.picture!);
    }
  }

  void onStatusSelected(int status) {
    formSource.sbccstmstatusid = status;
  }

  void onSubmitButtonClicked() async {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: NearbyString.updateCustomerConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
