import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';

class CustomerFormCreateListener extends StateListener {
  Property get _property => Get.find<Property>(tag: NearbyString.customerCreateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: NearbyString.customerCreateTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: NearbyString.customerCreateTag);

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }

  bool onCountryCompared(Country country, Country? selected) {
    return country.countryid == selected?.countryid;
  }

  bool onProvinceCompared(Province province, Province? selected) {
    return province.provid == selected?.provid;
  }

  bool onCityCompared(City city, City? selected) {
    return city.cityid == selected?.cityid;
  }

  bool onSubdistrictCompared(Subdistrict subdistrict, Subdistrict? selected) {
    return subdistrict.subdistrictid == selected?.subdistrictid;
  }

  void onTypeSelected(int type) {
    _formSource.cstmtypeid = type;
  }

  void onStatusSelected(int status) {
    _formSource.sbccstmstatusid = status;
  }

  void onMapControllerCreated(GoogleMapController controller) {
    if (!_property.mapsController.isCompleted) {
      _property.mapsController.complete(controller);
    }
  }

  Future onCountryFilter(String? search) async {
    List<Country> countries = await _dataSource.fetchCountries(search);
    return countries;
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

  void onSubmitButtonClicked() async {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: NearbyString.createCustomerConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataSuccess(String message) async {
    Get.find<TaskHelper>().loaderPop(_property.task.name);
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().property.refresh();
          Get.back(id: NearbyNavigator.id);
        }));
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
