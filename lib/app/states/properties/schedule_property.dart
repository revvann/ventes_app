import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleProperty extends StateProperty with PropertyMixin {
  final CalendarController calendarController = CalendarController();
  Task task = Task(ScheduleString.taskCode);

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  DateTime initialDate = DateTime.now();

  @override
  void ready() {
    super.ready();
    DateTime now = DateTime.now();

    selectedDate = DateTime(now.year, now.month, now.day);
    dateShown = calendarController.displayDate ?? now;
    initialDate = dateShown;

    calendarController.addPropertyChangedListener(listener.onDateShownChanged);
  }

  void refresh() {
    dataSource.appointmentsHandler.fetcher.run(dateShown.month);
    dataSource.permissionsHandler.fetcher.run();
    dataSource.typesHandler.fetcher.run();
  }

  @override
  void close() {
    super.close();
    calendarController.dispose();
  }
}
