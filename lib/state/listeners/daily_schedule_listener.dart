import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state/controllers/daily_schedule_state_controller.dart';

class DailyScheduleListener {
  DailyScheduleProperties get _properties => Get.find<DailyScheduleProperties>();

  void onArrowBackClick() {
    Get.back(id: ScheduleNavigator.id);
  }

  void onAddButtonClick() {
    Get.toNamed(ScheduleFormCreateView.route, id: ScheduleNavigator.id);
  }

  Color onFindAppointmentColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == _properties.dataSource.types["Event"]) {
      color = RegularColor.purple;
    } else if (appointment.schetypeid == _properties.dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == _properties.dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }

  void onEditButtonClick() {
    Get.toNamed(ScheduleFormUpdateView.route, id: ScheduleNavigator.id, arguments: {
      'scheduleId': _properties.selectedAppointment?.scheid,
    });
  }

  void onCalendarTap(CalendarTapDetails details) {
    _properties.selectedAppointment = details.appointments?.first;
  }
}
