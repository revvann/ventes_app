import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/data_sources/customer_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/customer_fu_form_source.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';
import 'package:path/path.dart' as path;

class CustomerFormUpdateListener {
  CustomerFormUpdateProperties get _properties => Get.find<CustomerFormUpdateProperties>();
  CustomerFormUpdateFormSource get _formSource => Get.find<CustomerFormUpdateFormSource>();
  CustomerFormUpdateDataSource get _dataSource => Get.find<CustomerFormUpdateDataSource>();

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }

  void onTypeSelected(int type) {
    _formSource.cstmtypeid = type;
  }

  void onMapControllerUpdated(GoogleMapController controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    _properties.markerLatLng = position.target;
    _formSource.cstmlatitude = position.target.latitude.toString();
    _formSource.cstmlongitude = position.target.longitude.toString();
  }

  void onCameraMoveEnd() {
    _properties.cameraMoveType = CameraMoveType.dragged;
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
    double newLat = double.tryParse(_formSource.cstmlatitude) ?? 0.0;
    double newLng = double.tryParse(_formSource.cstmlongitude) ?? 0.0;
    LatLng newPos = LatLng(newLat, newLng);

    double radius = calculateDistance(_properties.markers.first.position, newPos);
    bool inRange = radius <= 100;

    if (_formSource.isValid && inRange) {
      Map<String, dynamic> data = _formSource.toJson();
      data['_method'] = 'PUT';

      if (data['sbccstmpic'] != null) {
        String filename = path.basename(data['sbccstmpic']);
        data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);
      }

      FormData formData = FormData(data);
      _dataSource.updateCustomer(_formSource.sbcid!, formData);
      Get.find<TaskHelper>().loaderPush(NearbyString.updateTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(NearbyString.updateTaskCode, NearbyString.formInvalid);
    }
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(NearbyString.updateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(NearbyString.updateTaskCode);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(NearbyString.updateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(NearbyString.updateTaskCode);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(NearbyString.updateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(NearbyString.updateTaskCode);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(NearbyString.updateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(NearbyString.updateTaskCode);
  }

  void onUpdateDataSuccess(String message) async {
    Get.find<TaskHelper>().successPush(
      NearbyString.updateTaskCode,
      message,
      () {
        Get.find<NearbyStateController>().properties.refresh();
        Get.back(id: NearbyNavigator.id);
      },
    );
    Get.find<TaskHelper>().loaderPop(NearbyString.updateTaskCode);
  }
}
