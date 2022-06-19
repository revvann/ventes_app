import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

class ScheduleListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ScheduleString.scheduleTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ScheduleString.scheduleTag);

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if (_property.calendarController.displayDate != null) {
        _property.dateShown = _property.calendarController.displayDate!;
      }
      _dataSource.fetchSchedules(_property.dateShown.month);
      Get.find<TaskHelper>().loaderPush(_property.task);
    }
  }

  void onCalendarBackwardClick() {
    _property.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    _property.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    _property.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: ScheduleNavigator.id,
      arguments: {
        "date": _property.selectedDate,
      },
    );
  }

  Color onAppointmentFindColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == _dataSource.types["Event"]) {
      color = RegularColor.yellow;
    } else if (appointment.schetypeid == _dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == _dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }

  @override
  Future onReady() async {
    _property.refresh();
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }
}
