import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/app/state/controllers/schedule_state_controller.dart';

class ScheduleListener implements FetchDataContract {
  ScheduleProperties get _properties => Get.find<ScheduleProperties>();

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if (_properties.calendarController.displayDate != null) {
        _properties.dateShown = _properties.calendarController.displayDate!;
      }
      _properties.dataSource.fetchSchedules(_properties.dateShown.month);
      Loader().show();
    }
  }

  void onCalendarBackwardClick() {
    _properties.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    _properties.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    _properties.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: ScheduleNavigator.id,
      arguments: {
        "date": _properties.selectedDate,
      },
    );
  }

  Color onAppointmentFindColor(Schedule appointment) {
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

  @override
  onLoadFailed(String message) {
    Get.close(1);
    FailedAlert(message).show();
  }

  @override
  onLoadSuccess(Map data) {
    if (data['schedules'] != null) {
      _properties.dataSource.listToAppointments(data['schedules']);
    }
    if (data['types'] != null) {
      _properties.dataSource.listToTypes(data['types']);
    }
    Get.close(1);
  }

  @override
  onLoadError(String message) {
    Get.close(1);
    FailedAlert(message).show();
  }
}
