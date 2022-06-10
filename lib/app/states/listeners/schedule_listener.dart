part of 'package:ventes/app/states/controllers/schedule_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ScheduleString.scheduleTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ScheduleString.scheduleTag);

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if (_properties.calendarController.displayDate != null) {
        _properties.dateShown = _properties.calendarController.displayDate!;
      }
      _dataSource.fetchSchedules(_properties.dateShown.month);
      Get.find<TaskHelper>().loaderPush(ScheduleString.taskCode);
    }
  }

  void onCalendarBackwardClick() {
    _properties.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    _properties.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    _properties.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: ScheduleNavigator.id,
      arguments: {
        "date": _properties.selectedDate,
      },
    );
  }

  Color onAppointmentFindColor(Schedule appointment) {
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

  @override
  Future onRefresh() async {
    _properties.refresh();
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ScheduleString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(ScheduleString.taskCode);
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().failedPush(ScheduleString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(ScheduleString.taskCode);
  }
}
