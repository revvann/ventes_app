import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_fu_typedef.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.detailTypeCode,
  );

  TextEditingController prosdtdescTEC = TextEditingController();

  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  String? get dateString => date != null ? formatDate(date!) : null;

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
      tag: ProspectString.categoryDropdownTag,
    );
  }

  @override
  void prepareFormValues() async {
    prosdtdescTEC.text = dataSource.prospectactivity!.prospectdtdesc ?? "";
    date = dbParseDate(dataSource.prospectactivity!.prospectdtdate!);
    prosdttype = dataSource.prospectactivity!.prospectdttype;
    typeDropdownController.selectedKeys = [prosdttype!.typeid!];

    if (dataSource.prospectactivity?.prospectdtlatitude != null && dataSource.prospectactivity?.prospectdtlongitude != null) {
      double latitude = dataSource.prospectactivity!.prospectdtlatitude!;
      double longitude = dataSource.prospectactivity!.prospectdtlongitude!;
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
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdttypeid': prosdttype?.typeid.toString(),
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
