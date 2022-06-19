import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';

class DailyScheduleProperty extends StateProperty {
  DataSource get _dataSource => Get.find<DataSource>(tag: ScheduleString.dailyScheduleTag);

  Task task = Task(ScheduleString.dailyScheduleTaskCode);

  final Rx<DateTime> _date = Rx<DateTime>(DateTime.now());
  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = value;

  final Rx<Schedule?> _selectedAppointment = Rx<Schedule?>(null);
  Schedule? get selectedAppointment => _selectedAppointment.value;
  set selectedAppointment(Schedule? value) => _selectedAppointment.value = value;

  void refresh() {
    _dataSource.fetchData(dbFormatDate(date));
    Get.find<TaskHelper>().loaderPush(task);
  }

  Color getAppointmentColor(Schedule appointment) {
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
}
