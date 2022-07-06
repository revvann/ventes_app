import 'dart:io';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class CustomerFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

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

  set cstmtypeid(int? value) => _cstmtypeid.value = value;

  @override
  void ready() {
    super.ready();
    nameTEC.clear();
    addressTEC.clear();
    phoneTEC.clear();
    postalCodeTEC.clear();
  }

  @override
  void close() {
    super.close();
    nameTEC.dispose();
    addressTEC.dispose();
    phoneTEC.dispose();
    postalCodeTEC.dispose();
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

      if (dataSource.bpCustomer!.sbccstmpics != null) {
        defaultPicture.value = Image.network(dataSource.bpCustomer!.sbccstmpics!.first.url!);
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

    double radius = Utils.calculateDistance(property.markers.first.position, newPos);
    bool inRange = radius <= 100;

    if (isValid && inRange) {
      Map<String, dynamic> data = toJson();
      data['_method'] = 'PUT';

      if (data['sbccstmpic'] != null) {
        String filename = path.basename(data['sbccstmpic']);
        data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);
      }

      FormData formData = FormData(data);
      dataSource.updateHandler.fetcher.run(sbcid!, formData);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: NearbyString.formInvalid));
    }
  }
}
