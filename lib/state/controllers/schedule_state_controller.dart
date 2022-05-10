// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/state/controllers/regular_state_controller.dart';
import 'package:ventes/state/data_sources/schedule_data_source.dart';
import 'package:ventes/state/listeners/schedule_listener.dart';

class ScheduleStateController extends RegularStateController {
  ScheduleProperties properties = Get.put(ScheduleProperties());
  ScheduleListener listener = Get.put(ScheduleListener());

  @override
  void onInit() {
    super.onInit();
    properties.dataSource.fetchDataContract = listener;
  }

  @override
  void onReady() {
    super.onReady();
    DateTime now = DateTime.now();

    properties.selectedDate = DateTime(now.year, now.month, now.day);
    properties.dateShown = properties.calendarController.displayDate ?? now;
    properties.initialDate = properties.dateShown;

    properties.calendarController.addPropertyChangedListener(listener.onDateShownChanged);

    properties.dataSource.fetchData(properties.dateShown.month);
    Loader().show();
  }

  @override
  void onClose() {
    properties.calendarController.dispose();
    Get.delete<ScheduleProperties>();
    Get.delete<ScheduleListener>();
    super.onClose();
  }
}

class ScheduleProperties extends RegularStateController {
  ScheduleDataSource dataSource = ScheduleDataSource();

  final CalendarController calendarController = CalendarController();

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  DateTime initialDate = DateTime.now();
}
