import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/state_sources/data_sources/daily_schedule_data_source.dart';
import 'package:ventes/state_sources/state_listeners/daily_schedule_listener.dart';

class DailyScheduleStateController extends RegularStateController {
  DailyScheduleDataSource dataSource = DailyScheduleDataSource();
  late DailyScheduleListener listener;

  final Rx<DateTime> _date = Rx<DateTime>(DateTime.now());
  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = value;

  final Rx<Schedule?> _selectedAppointment = Rx<Schedule?>(null);
  Schedule? get selectedAppointment => _selectedAppointment.value;
  set selectedAppointment(Schedule? value) => _selectedAppointment.value = value;

  @override
  void onInit() {
    super.onInit();
    listener = DailyScheduleListener(this);
  }

  @override
  void onReady() {
    super.onReady();
    refetch();
  }

  void refetch() {
    dataSource.fetchSchedules(dbFormatDate(date));
    dataSource.fetchTypes();
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
