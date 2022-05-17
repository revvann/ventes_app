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

  void onCountrySelected(Country? country) {
    Country? provcountry = _formSource.provinceSearchListController.selectedItem?.provcountry;
    if (provcountry?.countryid != country?.countryid && provcountry != null) {
      _formSource.provinceSearchListController.reset();
      if (_formSource.citySearchListController.selectedItem != null) {
        _formSource.citySearchListController.reset();
        if (_formSource.subdistrictSearchListController.selectedItem != null) {
          _formSource.subdistrictSearchListController.reset();
        }
      }
    }
  }

  void onProvinceSelected(Province? province) {
    Province? cityprov = _formSource.citySearchListController.selectedItem?.cityprov;
    if (cityprov?.provid != province?.provid && cityprov != null) {
      _formSource.citySearchListController.reset();
      if (_formSource.subdistrictSearchListController.selectedItem != null) {
        _formSource.subdistrictSearchListController.reset();
      }
    }
  }

  void onCitySelected(City? city) {
    City? subdistrictcity = _formSource.subdistrictSearchListController.selectedItem?.subdistrictcity;
    if (subdistrictcity?.cityid != city?.cityid && subdistrictcity != null) {
      _formSource.subdistrictSearchListController.reset();
    }
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

  void onMapControllerCreated(GoogleMapController controller) {
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

  Future onCountryFilter(String? search) async {
    List<Country> countries = await _dataSource.fetchCountries(search);
    return countries;
  }

  Future onProvinceFilter(String? search) async {
    if (_formSource.country == null) {
      return <Province>[];
    }
    List<Province> provinces = await _dataSource.fetchProvinces(_formSource.country!.countryid!, search);
    return provinces;
  }

  Future onCityFilter(String? search) async {
    if (_formSource.province == null) {
      return <City>[];
    }
    List<City> cities = await _dataSource.fetchCities(_formSource.province!.provid!, search);
    return cities;
  }

  Future onSubdistrictFilter(String? search) async {
    if (_formSource.city == null) {
      return <Subdistrict>[];
    }
    List<Subdistrict> subdistricts = await _dataSource.fetchSubdistricts(_formSource.city!.cityid!, search);
    return subdistricts;
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
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      if (data['sbccstmpic'] != null) {
        String filename = path.basename(data['sbccstmpic']);
        data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);
      }

      // FormData formData = FormData(data);
      _dataSource.updateCustomer(_formSource.sbcid!, data);
      Loader().show();
    } else {
      FailedAlert(NearbyString.formInvalid).show();
    }
  }

  void onLoadDataError(String message) {
    Get.close(1);
    ErrorAlert(NearbyString.fetchError).show();
  }

  void onLoadDataFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.fetchFailed).show();
  }

  void onCreateDataError(String message) {
    Get.close(1);
    ErrorAlert(NearbyString.updateError).show();
  }

  void onCreateDataFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.updateFailed).show();
  }

  void onCreateDataSuccess(String message) async {
    Get.close(1);
    SuccessAlert(NearbyString.updateSuccess).show().then((res) {
      Get.find<NearbyStateController>().properties.refresh();
      Get.back(id: NearbyNavigator.id);
    });
  }
}
