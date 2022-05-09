import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state/controllers/schedule_state_controller.dart';

mixin ScheduleListener {
  ScheduleStateController get _$ => Get.find<ScheduleStateController>();

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if (_$.calendarController.displayDate != null) {
        _$.dateShown = _$.calendarController.displayDate!;
      }
      _$.dataSource.fetchSchedules(_$.dateShown.month);
      Loader().show();
    }
  }

  void onCalendarBackwardClick() {
    _$.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    _$.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    _$.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: ScheduleNavigator.id,
      arguments: {
        "date": _$.selectedDate,
      },
    );
  }

  Color onAppointmentFindColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == _$.dataSource.types["Event"]) {
      color = RegularColor.purple;
    } else if (appointment.schetypeid == _$.dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == _$.dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }
}
