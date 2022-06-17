part of 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';

class ScheduleFormCreateValidator {
  ScheduleFormCreateFormSource get _formSource => Get.find<ScheduleFormCreateFormSource>(tag: ScheduleString.scheduleCreateTag);
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
