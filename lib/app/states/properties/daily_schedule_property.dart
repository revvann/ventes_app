part of 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';

class DailyScheduleProperty extends StateProperty {
  DailyScheduleDataSource get _dataSource => Get.find<DailyScheduleDataSource>(tag: ScheduleString.dailyScheduleTag);

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
