part of 'package:ventes/app/states/controllers/schedule_state_controller.dart';

class ScheduleProperty extends StateProperty {
  ScheduleListener get _listener => Get.find<ScheduleListener>(tag: ScheduleString.scheduleTag);
  ScheduleDataSource get _dataSource => Get.find<ScheduleDataSource>(tag: ScheduleString.scheduleTag);

  final CalendarController calendarController = CalendarController();

  Task task = Task(ScheduleString.taskCode);

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  DateTime initialDate = DateTime.now();

  void refresh() {
    _dataSource.fetchData(dateShown.month);
    Get.find<TaskHelper>().loaderPush(task);
  }

  @override
  void ready() {
    super.close();
    DateTime now = DateTime.now();

    selectedDate = DateTime(now.year, now.month, now.day);
    dateShown = calendarController.displayDate ?? now;
    initialDate = dateShown;

    calendarController.addPropertyChangedListener(_listener.onDateShownChanged);
    refresh();
  }

  @override
  void close() {
    super.close();
    calendarController.dispose();
  }
}
