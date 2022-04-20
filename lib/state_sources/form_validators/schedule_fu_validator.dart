import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/state_sources/form_sources/schedule_fu_form_source.dart';

class ScheduleFormUpdateValidator {
  ScheduleFormUpdateValidator(this.formSource);
  ScheduleFormUpdateFormSource formSource;

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
