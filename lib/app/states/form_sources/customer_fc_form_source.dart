import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/states/form_validators/customer_fc_validator.dart';
import 'package:ventes/constants/strings/nearby_string.dart';

class CustomerFormCreateFormSource {
  late CustomerFormCreateValidator validator;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  final _country = Rx<Country?>(null);
  final _province = Rx<Province?>(null);
  final _city = Rx<City?>(null);
  final _subdistrict = Rx<Subdistrict?>(null);
  File? picture;

  set country(Country? value) => _country.value = value;
  Country? get country => _country.value;

  set province(Province? value) => _province.value = value;
  Province? get province => _province.value;

  set city(City? value) => _city.value = value;
  City? get city => _city.value;

  set subdistrict(Subdistrict? value) => _subdistrict.value = value;
  Subdistrict? get subdistrict => _subdistrict.value;

  init() async {
    validator = CustomerFormCreateValidator(this);
    picture = await _getImageFileFromAssets(NearbyString.defaultImage);
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
      'countryid': country?.countryid?.toString(),
      'provinceid': province?.provid?.toString(),
      'cityid': city?.cityid?.toString(),
      'subdistrictid': subdistrict?.subdistrictid?.toString(),
      'cstmpic': picture?.path,
    };
  }
}
