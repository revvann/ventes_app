import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/app/states/typedefs/schedule_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ScheduleListener extends StateListener with ListenerMixin {
  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if (property.calendarController.displayDate != null) {
        property.dateShown = property.calendarController.displayDate!;
      }
      dataSource.appointmentsHandler.fetcher.run(property.dateShown.month);
    }
  }

  void onCalendarBackwardClick() {
    property.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    property.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    property.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: Views.schedule.index,
      arguments: {
        "date": property.selectedDate,
      },
    );
  }

  Color onAppointmentFindColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == dataSource.types["Event"]) {
      color = RegularColor.yellow;
    } else if (appointment.schetypeid == dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
