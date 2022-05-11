import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';

class DailyScheduleListener implements FetchDataContract {
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

  @override
  onLoadFailed(String message) {
    Get.close(1);
    FailedAlert(message).show();
  }

  @override
  onLoadSuccess(Map data) {
    if (data['types'] != null) {
      _properties.dataSource.listToTypes(data['types']);
    }
    if (data['schedules'] != null) {
      _properties.dataSource.listToAppointments(data['schedules']);
    }
    Get.close(1);
  }

  @override
  onLoadError(String message) {
    Get.close(1);
    ErrorAlert(message).show();
  }
}
