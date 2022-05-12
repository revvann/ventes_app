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
import 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:path/path.dart' as path;

class CustomerFormCreateListener implements FetchDataContract, CreateContract {
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

  void onLongitudeValueChanged(latitude) {
    _formSource.latitudeTEC.text = latitude.toString();
  }

  void onLatitudeValueChanged(longitude) {
    _formSource.longitudeTEC.text = longitude.toString();
  }

  void onTypeSelected(int type) {
    _formSource.cstmtypeid = type;
  }

  void onMapControllerCreated(GoogleMapController controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  void onCameraMoved(position) {
    _properties.markerLatLng = position.target;
    _properties.latitude = position.target.latitude;
    _properties.longitude = position.target.longitude;
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

  void onSubmitButtonClicked() async {
    Map<String, dynamic> data = _formSource.toJson();
    String filename = path.basename(data['sbccstmpic']);
    data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);

    FormData formData = FormData(data);
    _properties.dataSource.createCustomer(formData);
    Loader().show();
  }

  @override
  onLoadError(String message) {
    Get.close(1);
    ErrorAlert(NearbyString.fetchError).show();
  }

  @override
  onLoadFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.fetchFailed).show();
  }

  @override
  onLoadSuccess(Map data) {
    if (data['customers'] != null) {
      _properties.deployCustomers(data['customers']);
    }

    if (data['types'] != null) {
      _properties.dataSource.typesFromList(data['types']);
    }

    if (data['user'] != null) {
      _formSource.sbcbpid = UserDetail.fromJson(data['user']).userdtbpid;
    }

    Get.close(1);
  }

  @override
  void onCreateError(String message) {
    Get.close(1);
    ErrorAlert(NearbyString.createError).show();
  }

  @override
  void onCreateFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.createFailed).show();
  }

  @override
  void onCreateSuccess(String message) {
    Get.close(1);
    SuccessAlert(NearbyString.createSuccess).show();
  }
}
