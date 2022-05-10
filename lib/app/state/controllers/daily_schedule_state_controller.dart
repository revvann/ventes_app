import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/state/controllers/regular_state_controller.dart';
import 'package:ventes/app/state/data_sources/daily_schedule_data_source.dart';
import 'package:ventes/app/state/listeners/daily_schedule_listener.dart';

class DailyScheduleStateController extends RegularStateController {
  DailyScheduleProperties properties = Get.put(DailyScheduleProperties());
  DailyScheduleListener listener = Get.put(DailyScheduleListener());

  @override
  void onInit() {
    super.onInit();
    properties.dataSource.fetchDataContract = listener;
  }

  @override
  void onReady() {
    super.onReady();
    properties.refetch();
  }

  @override
  void onClose() {
    Get.delete<DailyScheduleProperties>();
    Get.delete<DailyScheduleListener>();
    super.onClose();
  }
}

class DailyScheduleProperties {
  DailyScheduleDataSource dataSource = DailyScheduleDataSource();

  final Rx<DateTime> _date = Rx<DateTime>(DateTime.now());
  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = value;

  final Rx<Schedule?> _selectedAppointment = Rx<Schedule?>(null);
  Schedule? get selectedAppointment => _selectedAppointment.value;
  set selectedAppointment(Schedule? value) => _selectedAppointment.value = value;

  void refetch() {
    dataSource.fetchData(dbFormatDate(date));
    Loader().show();
  }

  Color getAppointmentColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == dataSource.types["Event"]) {
      color = RegularColor.purple;
    } else if (appointment.schetypeid == dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }
}
