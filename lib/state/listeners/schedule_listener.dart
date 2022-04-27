import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state/controllers/schedule_state_controller.dart';

class ScheduleListener {
  ScheduleStateController get $ => Get.find<ScheduleStateController>();

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if ($.calendarController.displayDate != null) {
        $.dateShown = $.calendarController.displayDate!;
      }
      $.dataSource.fetchSchedules($.dateShown.month);
      Loader().show();
    }
  }

  void onCalendarBackwardClick() {
    $.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    $.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    $.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: ScheduleNavigator.id,
      arguments: {
        "date": $.selectedDate,
      },
    );
  }

  Color onAppointmentFindColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == $.dataSource.types["Event"]) {
      color = RegularColor.purple;
    } else if (appointment.schetypeid == $.dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == $.dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }
}
