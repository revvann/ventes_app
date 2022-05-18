import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
import 'package:ventes/app/states/form_validators/customer_fc_validator.dart';
import 'package:ventes/constants/strings/nearby_string.dart';

class CustomerFormCreateFormSource {
  late CustomerFormCreateValidator validator;
  final CustomerFormCreateProperties _properties = Get.find<CustomerFormCreateProperties>();
  final CustomerFormCreateDataSource _dataSource = Get.find<CustomerFormCreateDataSource>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController latitudeTEC = TextEditingController();
  TextEditingController longitudeTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();

  File? picture;
  int? sbccstmstatusid;
  int? sbcbpid;

  final Rx<int?> _cstmtypeid = Rx<int?>(null);
  Rx<int?> _provinceid = Rx(null);
  Rx<int?> _cityid = Rx(null);
  Rx<int?> _subdistrictid = Rx(null);

  String get cstmlatitude => latitudeTEC.text;
  String get cstmlongitude => longitudeTEC.text;
  String get cstmname => nameTEC.text;
  String get cstmaddress => addressTEC.text;
  String get cstmphone => phoneTEC.text;

  int? get cstmtypeid => _cstmtypeid.value;
  int? get provinceid => _provinceid.value;
  int? get cityid => _cityid.value;
  int? get subdistrictid => _subdistrictid.value;

  set cstmtypeid(int? value) => _cstmtypeid.value = value;
  set provinceid(int? value) => _provinceid.value = value;
  set cityid(int? value) => _cityid.value = value;
  set subdistrictid(int? value) => _subdistrictid.value = value;

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
    latitudeTEC.dispose();
    longitudeTEC.dispose();
    Get.delete<SearchListController<Country, Country>>();
    Get.delete<SearchListController<Province, Province>>();
    Get.delete<SearchListController<City, City>>();
    Get.delete<SearchListController<Subdistrict, Subdistrict>>();
  }

  void prepareValues(Customer customer) {
    nameTEC.text = customer.cstmname ?? "";
    addressTEC.text = customer.cstmaddress ?? "";
    phoneTEC.text = customer.cstmphone ?? "";
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
      'sbccstmstatusid': sbccstmstatusid?.toString(),
      'cstmname': cstmname,
      'cstmaddress': cstmaddress,
      'cstmphone': cstmphone,
      'cstmpostalcode': _dataSource.getPostalCodeName(),
      'cstmprovinceid': provinceid.toString(),
      'cstmcityid': cityid.toString(),
      'cstmsubdistrictid': subdistrictid.toString(),
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };
  }
}
