import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';

class CustomerFormCreateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

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

  @override
  init() async {
    super.init();
    picture = await _getImageFileFromAssets(NearbyString.defaultImage);

    latitudeTEC.text = property.latitude!.toString();
    longitudeTEC.text = property.longitude!.toString();
  }

  @override
  void close() {
    super.close();
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

  @override
  void prepareFormValues() {
    nameTEC.text = dataSource.customer!.cstmname ?? "";
    addressTEC.text = dataSource.customer!.cstmaddress ?? "";
    phoneTEC.text = dataSource.customer!.cstmphone ?? "";
    cstmtypeid = dataSource.customer!.cstmtypeid;
    provinceid = dataSource.customer!.cstmprovinceid;
    cityid = dataSource.customer!.cstmcityid;
    subdistrictid = dataSource.customer!.cstmsubdistrictid;
    cstmid = dataSource.customer!.cstmid;
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> formData = {
      'sbccstmpic': picture?.path,
      'sbcbpid': sbcbpid.toString(),
      'sbccstmstatusid': sbccstmstatusid?.toString(),
      'cstmid': cstmid?.toString(),
      'cstmname': cstmname,
      'cstmaddress': cstmaddress,
      'cstmphone': cstmphone,
      'cstmpostalcode': dataSource.getPostalCodeName(),
      'cstmprovinceid': provinceid.toString(),
      'cstmcityid': cityid.toString(),
      'cstmsubdistrictid': subdistrictid.toString(),
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };

    return formData;
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      String filename = path.basename(data['sbccstmpic']);
      data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);

      FormData formData = FormData(data);
      dataSource.createCustomer(formData);
      Get.find<TaskHelper>().loaderPush(property.task);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: NearbyString.formInvalid));
    }
  }
}
