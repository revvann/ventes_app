import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/daily_schedule_data_source.dart';
import 'package:ventes/app/states/listeners/daily_schedule_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class DailyScheduleStateController extends RegularStateController {
  @override
  bool get isFixedBody => false;

  DailyScheduleProperties properties = Get.put(DailyScheduleProperties());
  DailyScheduleListener listener = Get.put(DailyScheduleListener());
  DailyScheduleDataSource dataSource = Get.put(DailyScheduleDataSource());

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.refresh();
  }

  @override
  void onClose() {
    Get.delete<DailyScheduleProperties>();
    Get.delete<DailyScheduleListener>();
    Get.delete<DailyScheduleDataSource>();
    super.onClose();
  }
}

class DailyScheduleProperties {
  DailyScheduleDataSource get _dataSource => Get.find<DailyScheduleDataSource>();

  final Rx<DateTime> _date = Rx<DateTime>(DateTime.now());
  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = value;

  final Rx<Schedule?> _selectedAppointment = Rx<Schedule?>(null);
  Schedule? get selectedAppointment => _selectedAppointment.value;
  set selectedAppointment(Schedule? value) => _selectedAppointment.value = value;

  void refresh() {
    _dataSource.fetchData(dbFormatDate(date));
    Get.find<TaskHelper>().add(ScheduleString.dailyScheduleTaskCode);
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
