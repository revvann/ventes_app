import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:ventes/app/states/form_validators/customer_fc_validator.dart';
import 'package:ventes/app/states/listeners/customer_fc_listener.dart';
import 'package:ventes/constants/strings/nearby_string.dart';

class CustomerFormCreateFormSource {
  late CustomerFormCreateValidator validator;
  final CustomerFormCreateProperties _properties = Get.find<CustomerFormCreateProperties>();
  final CustomerFormCreateListener _listener = Get.find<CustomerFormCreateListener>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController latitudeTEC = TextEditingController();
  TextEditingController longitudeTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController postalCodeTEC = TextEditingController();

  final _country = Rx<Country?>(null);
  final _province = Rx<Province?>(null);
  final _city = Rx<City?>(null);
  final _subdistrict = Rx<Subdistrict?>(null);

  File? picture;
  int? cstmtypeid;
  int? sbcbpid;

  set country(Country? value) => _country.value = value;
  Country? get country => _country.value;

  set province(Province? value) => _province.value = value;
  Province? get province => _province.value;

  set city(City? value) => _city.value = value;
  City? get city => _city.value;

  set subdistrict(Subdistrict? value) => _subdistrict.value = value;
  Subdistrict? get subdistrict => _subdistrict.value;

  String get cstmlatitude => latitudeTEC.text;
  String get cstmlongitude => longitudeTEC.text;
  String get cstmname => nameTEC.text;
  String get cstmaddress => addressTEC.text;
  String get cstmphone => phoneTEC.text;
  String get cstmpostalcode => postalCodeTEC.text;

  init() async {
    validator = CustomerFormCreateValidator(this);
    picture = await _getImageFileFromAssets(NearbyString.defaultImage);

    _properties.rxLatitude.stream.listen(_listener.onLatitudeValueChanged);
    _properties.rxLongitude.stream.listen(_listener.onLongitudeValueChanged);
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
      'cstmcountryid': country?.countryid?.toString(),
      'cstmprovinceid': province?.provid?.toString(),
      'cstmcityid': city?.cityid?.toString(),
      'cstmsubdistrictid': subdistrict?.subdistrictid?.toString(),
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };
  }
}
