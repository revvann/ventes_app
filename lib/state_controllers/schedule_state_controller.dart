// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/state_sources/data_sources/schedule_data_source.dart';
import 'package:ventes/state_sources/state_listeners/schedule_listener.dart';

class ScheduleStateController extends RegularStateController {
  ScheduleDataSource dataSource = ScheduleDataSource();
  late ScheduleListener listener;

  final CalendarController calendarController = CalendarController();

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  DateTime initialDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    listener = ScheduleListener(this);
  }

  @override
  void onReady() {
    super.onReady();
    DateTime now = DateTime.now();

    selectedDate = DateTime(now.year, now.month, now.day);
    dateShown = calendarController.displayDate ?? now;
    initialDate = dateShown;

    calendarController.addPropertyChangedListener(listener.onDateShownChanged);
    dataSource.fetchSchedules(dateShown.month);
    dataSource.fetchTypes();
    Loader().show();
  }

  @override
  void onClose() {
    calendarController.dispose();
    super.onClose();
  }
}
