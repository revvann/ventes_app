import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';

class CustomerFormCreateListener extends StateListener with ListenerMixin {
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
    formSource.cstmtypeid = type;
  }

  void onStatusSelected(int status) {
    formSource.sbccstmstatusid = status;
  }

  void onMapControllerCreated(GoogleMapController controller) {
    if (!property.mapsController.isCompleted) {
      property.mapsController.complete(controller);
    }
  }

  Future onCountryFilter(String? search) async {
    List<Country> countries = await dataSource.fetchCountries(search);
    return countries;
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

  void onSubmitButtonClicked() async {
    if (formSource.isValid) {
      Get.find<TaskHelper>().confirmPush(
        property.task.copyWith<bool>(
          message: NearbyString.createCustomerConfirm,
          onFinished: (res) {
            if (res) {
              dataSource.nearbyCustomersHandler.fetcher.run(formSource.subdistrictid!);
            }
          },
        ),
      );
    }
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
