import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/widgets/regular_time_picker.dart';

class ScheduleStateController extends RegularStateController {
  final filterTimeInputController = TextEditingController();
  final CalendarController calendarController = CalendarController();

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  void changeTime() async {
    TimeOfDay? time = await RegularTimePicker().show();
    if (time != null) {
      final localizations = MaterialLocalizations.of(Get.context!);
      final formattedTimeOfDay = localizations.formatTimeOfDay(time);
      filterTimeInputController.text = formattedTimeOfDay;
    }
  }

  @override
  void onInit() {
    super.onInit();
    filterTimeInputController.text = MaterialLocalizations.of(Get.context!).formatTimeOfDay(TimeOfDay.now());
  }

  @override
  void onReady() {
    super.onReady();
    DateTime now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    dateShown = calendarController.displayDate ?? now;
    calendarController.addPropertyChangedListener((_) {
      dateShown = calendarController.displayDate ?? now;
    });
  }

  @override
  void onClose() {
    calendarController.dispose();
    filterTimeInputController.dispose();
    super.onClose();
  }
}
