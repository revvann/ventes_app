import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_fu_typedef.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.detailTypeDropdownTag,
  );

  TextEditingController prosdtdescTEC = TextEditingController();

  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);
  final Rx<int?> _prosdtcatid = Rx<int?>(null);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  int? get prosdtcatid => _prosdtcatid.value;
  set prosdtcatid(int? value) => _prosdtcatid.value = value;

  String? get dateString => date != null ? Utils.formatDate(date!) : null;

  @override
  init() {
    super.init();
    validator.formSource = this;
  }

  @override
  ready() {
    super.ready();
    prosdtdescTEC.clear();
    typeDropdownController.reset();

    date = DateTime.now();
  }

  @override
  void close() {
    super.close();
    prosdtdescTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeDropdownTag,
    );
  }

  @override
  void prepareFormValues() async {
    if (dataSource.prospectactivity!.prospectactivitydesc != null) prosdtdescTEC.text = dataSource.prospectactivity!.prospectactivitydesc ?? "";
    if (dataSource.prospectactivity!.prospectactivitydate != null) date = Utils.dbParseDate(dataSource.prospectactivity!.prospectactivitydate!);
    if (dataSource.prospectactivity!.prospectactivitytype != null) {
      prosdttype = dataSource.prospectactivity!.prospectactivitytype;
      typeDropdownController.selectedKeys = [prosdttype!.typeid!];
    }
    if (dataSource.prospectactivity!.prospectactivitycatid != null) {
      prosdtcatid = dataSource.prospectactivity?.prospectactivitycatid;
    }

    if (dataSource.prospectactivity?.prospectactivitylatitude != null && dataSource.prospectactivity?.prospectactivitylongitude != null) {
      double latitude = dataSource.prospectactivity!.prospectactivitylatitude!;
      double longitude = dataSource.prospectactivity!.prospectactivitylongitude!;
      LatLng latLng = LatLng(latitude, longitude);

      GoogleMapController controller = await property.mapsController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );

      Marker marker = Marker(
        markerId: MarkerId("Current Position"),
        position: latLng,
      );
      property.marker = {marker};
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectactivitydesc': prosdtdescTEC.text,
      'prospectactivitydate': Utils.dbDateFormat(date!),
      'prospectactivitytypeid': prosdttype?.typeid,
      'prospectactivitycatid': prosdtcatid,
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.updateHandler.fetcher.run(property.prospectActivityId, data);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: "Form invalid, Make sure all fields are filled"));
    }
  }
}
