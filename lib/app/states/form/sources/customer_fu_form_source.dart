import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class CustomerFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  SearchListController<Country, Country> countrySearchListController = Get.put(SearchListController<Country, Country>());
  SearchListController<Province, Province> provinceSearchListController = Get.put(SearchListController<Province, Province>());
  SearchListController<City, City> citySearchListController = Get.put(SearchListController<City, City>());
  SearchListController<Subdistrict, Subdistrict> subdistrictSearchListController = Get.put(SearchListController<Subdistrict, Subdistrict>());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<Image> defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController postalCodeTEC = TextEditingController();

  File? picture;
  int? sbcid;
  String cstmlatitude = '0';
  String cstmlongitude = '0';
  int? sbccstmstatusid;

  final Rx<int?> _cstmtypeid = Rx<int?>(null);

  int? get cstmtypeid => _cstmtypeid.value;
  String get cstmname => nameTEC.text;
  String get cstmaddress => addressTEC.text;
  String get cstmphone => phoneTEC.text;
  String get cstmpostalcode => postalCodeTEC.text;
  String? get cstmcoutryid => countrySearchListController.selectedItem?.countryid.toString();
  String? get cstmprovinceid => provinceSearchListController.selectedItem?.provid.toString();
  String? get cstmcityid => citySearchListController.selectedItem?.cityid.toString();
  String? get cstmsubdistrictid => subdistrictSearchListController.selectedItem?.subdistrictid.toString();

  Country? get country => countrySearchListController.selectedItem;
  Province? get province => provinceSearchListController.selectedItem;
  City? get city => citySearchListController.selectedItem;
  Subdistrict? get subdistrict => subdistrictSearchListController.selectedItem;

  set cstmtypeid(int? value) => _cstmtypeid.value = value;

  @override
  void close() {
    super.close();
    nameTEC.dispose();
    addressTEC.dispose();
    phoneTEC.dispose();
    postalCodeTEC.dispose();
    Get.delete<SearchListController<Country, Country>>();
    Get.delete<SearchListController<Province, Province>>();
    Get.delete<SearchListController<City, City>>();
    Get.delete<SearchListController<Subdistrict, Subdistrict>>();
  }

  @override
  void prepareFormValues() {
    if (dataSource.bpCustomer != null) {
      sbcid = dataSource.bpCustomer!.sbcid;

      cstmlatitude = dataSource.bpCustomer!.sbccstm!.cstmlatitude!.toString();
      cstmlongitude = dataSource.bpCustomer!.sbccstm!.cstmlongitude!.toString();
      property.markerLatLng = LatLng(double.parse(cstmlatitude), double.parse(cstmlongitude));

      nameTEC.text = dataSource.bpCustomer!.sbccstm!.cstmname ?? "";
      addressTEC.text = dataSource.bpCustomer!.sbccstm!.cstmaddress ?? "";
      phoneTEC.text = dataSource.bpCustomer!.sbccstm!.cstmphone ?? "";
      postalCodeTEC.text = dataSource.bpCustomer!.sbccstm!.cstmpostalcode ?? "";

      cstmtypeid = dataSource.bpCustomer!.sbccstm!.cstmtypeid;

      if (dataSource.bpCustomer!.sbccstmpic != null) {
        defaultPicture.value = Image.network(dataSource.bpCustomer!.sbccstmpic!);
      }

      if (dataSource.bpCustomer!.sbccstm!.cstmcountry != null) {
        countrySearchListController.selectedItem = dataSource.bpCustomer!.sbccstm!.cstmcountry!;
      }

      if (dataSource.bpCustomer!.sbccstm!.cstmprovince != null) {
        provinceSearchListController.selectedItem = dataSource.bpCustomer!.sbccstm!.cstmprovince!;
      }

      if (dataSource.bpCustomer!.sbccstm!.cstmcity != null) {
        citySearchListController.selectedItem = dataSource.bpCustomer!.sbccstm!.cstmcity!;
      }

      if (dataSource.bpCustomer!.sbccstm!.cstmsubdistrict != null) {
        subdistrictSearchListController.selectedItem = dataSource.bpCustomer!.sbccstm!.cstmsubdistrict!;
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sbccstmpic': picture?.path,
      'sbccstmstatusid': sbccstmstatusid,
      'cstmname': cstmname,
      'cstmaddress': cstmaddress,
      'cstmphone': cstmphone,
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };
  }

  @override
  void onSubmit() {
    double newLat = double.tryParse(cstmlatitude) ?? 0.0;
    double newLng = double.tryParse(cstmlongitude) ?? 0.0;
    LatLng newPos = LatLng(newLat, newLng);

    double radius = calculateDistance(property.markers.first.position, newPos);
    bool inRange = radius <= 100;

    if (isValid && inRange) {
      Map<String, dynamic> data = toJson();
      data['_method'] = 'PUT';

      if (data['sbccstmpic'] != null) {
        String filename = path.basename(data['sbccstmpic']);
        data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);
      }

      FormData formData = FormData(data);
      dataSource.updateCustomer(sbcid!, formData);
      Get.find<TaskHelper>().loaderPush(property.task);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: NearbyString.formInvalid));
    }
  }
}