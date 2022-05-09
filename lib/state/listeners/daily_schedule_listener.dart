import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state/controllers/daily_schedule_state_controller.dart';

mixin DailyScheduleListener {
  DailyScheduleStateController get _$ => Get.find<DailyScheduleStateController>();

  void onArrowBackClick() {
    Get.back(id: ScheduleNavigator.id);
  }

  void onAddButtonClick() {
    Get.toNamed(ScheduleFormCreateView.route, id: ScheduleNavigator.id);
  }

  Color onFindAppointmentColor(Schedule appointment) {
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

  void onEditButtonClick() {
    Get.toNamed(ScheduleFormUpdateView.route, id: ScheduleNavigator.id, arguments: {
      'scheduleId': _$.selectedAppointment?.scheid,
    });
  }

  void onCalendarTap(CalendarTapDetails details) {
    _$.selectedAppointment = details.appointments?.first;
  }
}
