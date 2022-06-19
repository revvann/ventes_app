import 'package:get/get.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';

class ScheduleFormCreateValidator {
  FormSource get _formSource => Get.find<FormSource>(tag: ScheduleString.scheduleCreateTag);
  String? schenm(String? value) {
    if (value == null || value.isEmpty) {
      return ScheduleString.schenmInvalid;
    }
  }

  String? scheonlink(String? value) {
    if (_formSource.isEvent) {
      if (_formSource.scheonline) {
        if (value == null || value.isEmpty) {
          return ScheduleString.scheonlinkInvalid;
        }
      }
    }
  }

  String? scheloc(String? value) {
    if (_formSource.isEvent) {
      if (!_formSource.scheonline) {
        if (value == null || value.isEmpty) {
          return ScheduleString.schelocInvalid;
        }
      }
    }
  }
}
