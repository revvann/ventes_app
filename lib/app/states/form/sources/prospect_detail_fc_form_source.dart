import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormCreateFormSource extends StateFormSource with FormSourceMixin {
  Validator validator = Validator();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  KeyableDropdownController<int, DBType> categoryDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.categoryDropdownTag,
  );

  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.detailTypeCode,
  );

  TextEditingController prosdtdescTEC = TextEditingController();

  final Rx<DBType?> _prosdtcategory = Rx<DBType?>(null);
  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);
  Prospect? prospect;
  final Rx<String?> _prosdtloc = Rx<String?>(null);
  double? prosdtlat;
  double? prosdtlong;

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdtcategory => _prosdtcategory.value;
  set prosdtcategory(DBType? value) => _prosdtcategory.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  String? get prosdtloc => _prosdtloc.value;
  set prosdtloc(String? value) => _prosdtloc.value = value;

  String? get dateString => date != null ? formatDate(date!) : null;

  @override
  init() async {
    super.init();
    validator.formSource = this;
  }

  @override
  ready() async {
    super.ready();
    date = DateTime.now();

    Position pos = await getCurrentPosition();
    prosdtlat = pos.latitude;
    prosdtlong = pos.longitude;
    prosdtloc = "https://maps.google.com?q=$prosdtlat,$prosdtlong";

    Marker marker = Marker(
      markerId: MarkerId("currentloc"),
      position: LatLng(prosdtlat ?? 0, prosdtlong ?? 0),
      infoWindow: InfoWindow(
        title: "Current position",
      ),
    );
    property.marker = {marker};

    property.mapsController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(prosdtlat ?? 0, prosdtlong ?? 0)),
      );
    });
  }

  @override
  void close() {
    super.close();
    prosdtdescTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.categoryDropdownTag,
    );
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeCode,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectdtprospectid': prospect?.prospectid?.toString(),
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdtcatid': prosdtcategory?.typeid.toString(),
      'prospectdttypeid': prosdttype?.typeid.toString(),
      'prospectdtloc': prosdtloc,
      'prospectdtlatitude': prosdtlat.toString(),
      'prospectdtlongitude': prosdtlong.toString(),
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.createData(data);
      Get.find<TaskHelper>().loaderPush(property.task);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: "Form invalid, Make sure all fields are filled"));
    }
  }
}
