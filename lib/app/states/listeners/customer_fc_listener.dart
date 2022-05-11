import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';

class CustomerFormCreateListener {
  CustomerFormCreateProperties get _properties => Get.find<CustomerFormCreateProperties>();
  CustomerFormCreateFormSource get _formSource => Get.find<CustomerFormCreateFormSource>();

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }

  void onCountrySelected(Country country) {
    _formSource.country = country;
  }

  void onProvinceSelected(Province province) {
    _formSource.province = province;
  }

  void onCitySelected(City city) {
    _formSource.city = city;
  }

  void onSubdistrictSelected(Subdistrict subdistrict) {
    _formSource.subdistrict = subdistrict;
  }

  Future onCountryFilter(String? search) async {
    List<Country> countries = await _properties.dataSource.fetchCountries(search);
    return countries;
  }

  Future onProvinceFilter(String? search) async {
    if (_formSource.country == null) {
      return <Province>[];
    }
    List<Province> provinces = await _properties.dataSource.fetchProvinces(_formSource.country!.countryid!, search);
    return provinces;
  }

  Future onCityFilter(String? search) async {
    if (_formSource.province == null) {
      return <City>[];
    }
    List<City> cities = await _properties.dataSource.fetchCities(_formSource.province!.provid!, search);
    return cities;
  }

  Future onSubdistrictFilter(String? search) async {
    if (_formSource.city == null) {
      return <Subdistrict>[];
    }
    List<Subdistrict> subdistricts = await _properties.dataSource.fetchSubdistricts(_formSource.city!.cityid!, search);
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
}
