import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:path/path.dart' as path;

class CustomerFormCreateListener {
  CustomerFormCreateProperties get _properties => Get.find<CustomerFormCreateProperties>();
  CustomerFormCreateFormSource get _formSource => Get.find<CustomerFormCreateFormSource>();
  CustomerFormCreateDataSource get _dataSource => Get.find<CustomerFormCreateDataSource>();

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
      String filename = path.basename(data['sbccstmpic']);
      data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);

      FormData formData = FormData(data);
      _dataSource.createCustomer(formData);
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
    ErrorAlert(NearbyString.createError).show();
  }

  void onCreateDataFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.createFailed).show();
  }

  void onCreateDataSuccess(String message) async {
    Get.close(1);
    SuccessAlert(NearbyString.createSuccess).show();
    Get.find<NearbyStateController>().properties.refresh();
    Get.back(id: NearbyNavigator.id);
  }
}
