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
  CustomerFormCreateProperties get _properties => Get.find<CustomerFormCreateProperties>();
  CustomerFormCreateDataSource get _dataSource => Get.find<CustomerFormCreateDataSource>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController latitudeTEC = TextEditingController();
  TextEditingController longitudeTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();

  int? cstmid;
  File? picture;
  int? sbccstmstatusid;
  int? sbcbpid;
  int? provinceid;
  int? cityid;
  int? subdistrictid;

  final Rx<int?> _cstmtypeid = Rx<int?>(null);

  String get cstmlatitude => latitudeTEC.text;
  String get cstmlongitude => longitudeTEC.text;
  String get cstmname => nameTEC.text;
  String get cstmaddress => addressTEC.text;
  String get cstmphone => phoneTEC.text;

  int? get cstmtypeid => _cstmtypeid.value;

  set cstmtypeid(int? value) => _cstmtypeid.value = value;

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

  void prepareValues() {
    nameTEC.text = _dataSource.customer!.cstmname ?? "";
    addressTEC.text = _dataSource.customer!.cstmaddress ?? "";
    phoneTEC.text = _dataSource.customer!.cstmphone ?? "";
    cstmtypeid = _dataSource.customer!.cstmtypeid;
    provinceid = _dataSource.customer!.cstmprovinceid;
    cityid = _dataSource.customer!.cstmcityid;
    subdistrictid = _dataSource.customer!.cstmsubdistrictid;
    cstmid = _dataSource.customer!.cstmid;
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> formData = {
      'sbccstmpic': picture?.path,
      'sbcbpid': sbcbpid.toString(),
      'sbccstmstatusid': sbccstmstatusid?.toString(),
      'cstmid': cstmid?.toString(),
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

    return formData;
  }
}
