import 'package:get/get.dart';
import 'package:ventes/app/states/form/sources/schedule_fu_form_source.dart';
import 'package:ventes/constants/strings/schedule_string.dart';

class ScheduleFormUpdateValidator {
  ScheduleFormUpdateFormSource get _formSource => Get.find<ScheduleFormUpdateFormSource>(tag: ScheduleString.scheduleUpdateTag);

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
