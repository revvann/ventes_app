import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:ventes/app/states/form_validators/customer_fc_validator.dart';
import 'package:ventes/constants/strings/nearby_string.dart';

class CustomerFormCreateFormSource {
  late CustomerFormCreateValidator validator;
  final CustomerFormCreateProperties _properties = Get.find<CustomerFormCreateProperties>();

  SearchListController<Country, Country> countrySearchListController = Get.put(SearchListController<Country, Country>());
  SearchListController<Province, Province> provinceSearchListController = Get.put(SearchListController<Province, Province>());
  SearchListController<City, City> citySearchListController = Get.put(SearchListController<City, City>());
  SearchListController<Subdistrict, Subdistrict> subdistrictSearchListController = Get.put(SearchListController<Subdistrict, Subdistrict>());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController latitudeTEC = TextEditingController();
  TextEditingController longitudeTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController postalCodeTEC = TextEditingController();

  File? picture;
  int? cstmtypeid;
  int? sbcbpid;

  String get cstmlatitude => latitudeTEC.text;
  String get cstmlongitude => longitudeTEC.text;
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

  init() async {
    validator = CustomerFormCreateValidator(this);
    picture = await _getImageFileFromAssets(NearbyString.defaultImage);

    latitudeTEC.text = _properties.latitude!.toString();
    longitudeTEC.text = _properties.longitude!.toString();
  }

  dispose() {
    nameTEC.dispose();
    addressTEC.dispose();
    phoneTEC.dispose();
    postalCodeTEC.dispose();
    latitudeTEC.dispose();
    longitudeTEC.dispose();
    Get.delete<SearchListController<Country, Country>>();
    Get.delete<SearchListController<Province, Province>>();
    Get.delete<SearchListController<City, City>>();
    Get.delete<SearchListController<Subdistrict, Subdistrict>>();
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Map<String, dynamic> toJson() {
    return {
      'sbccstmpic': picture?.path,
      'sbcbpid': sbcbpid.toString(),
      'cstmname': cstmname,
      'cstmaddress': cstmaddress,
      'cstmphone': cstmphone,
      'cstmpostalcode': cstmpostalcode,
      'cstmcountryid': cstmcoutryid,
      'cstmprovinceid': cstmprovinceid,
      'cstmcityid': cstmcityid,
      'cstmsubdistrictid': cstmsubdistrictid,
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };
  }
}
