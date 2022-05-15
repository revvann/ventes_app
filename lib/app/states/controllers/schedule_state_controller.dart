// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/schedule_data_source.dart';
import 'package:ventes/app/states/listeners/schedule_listener.dart';

class ScheduleStateController extends RegularStateController {
  ScheduleProperties properties = Get.put(ScheduleProperties());
  ScheduleListener listener = Get.put(ScheduleListener());
  ScheduleDataSource dataSource = Get.put(ScheduleDataSource());

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.ready();
  }

  @override
  void onClose() {
    properties.calendarController.dispose();
    Get.delete<ScheduleProperties>();
    Get.delete<ScheduleListener>();
    Get.delete<ScheduleDataSource>();
    super.onClose();
  }
}

class ScheduleProperties extends RegularStateController {
  ScheduleListener get _listener => Get.find<ScheduleListener>();
  ScheduleDataSource get _dataSource => Get.find<ScheduleDataSource>();

  final CalendarController calendarController = CalendarController();

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  DateTime initialDate = DateTime.now();

  void ready() {
    DateTime now = DateTime.now();

    selectedDate = DateTime(now.year, now.month, now.day);
    dateShown = calendarController.displayDate ?? now;
    initialDate = dateShown;

    calendarController.addPropertyChangedListener(_listener.onDateShownChanged);

    _dataSource.fetchData(dateShown.month);
    Loader().show();
  }
}
