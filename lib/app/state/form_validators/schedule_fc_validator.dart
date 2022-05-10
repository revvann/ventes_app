import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/state/form_sources/schedule_fc_form_source.dart';

class ScheduleFormCreateValidator {
  ScheduleFormCreateValidator(this.formSource);
  ScheduleFormCreateFormSource formSource;

  String? schenm(String? value) {
    if (value == null || value.isEmpty) {
      return ScheduleString.schenmInvalid;
    }
  }

  String? scheonlink(String? value) {
    if (formSource.isEvent) {
      if (formSource.scheonline) {
        if (value == null || value.isEmpty) {
          return ScheduleString.scheonlinkInvalid;
        }
      }
    }
  }

  String? scheloc(String? value) {
    if (formSource.isEvent) {
      if (!formSource.scheonline) {
        if (value == null || value.isEmpty) {
          return ScheduleString.schelocInvalid;
        }
      }
    }
  }
}
