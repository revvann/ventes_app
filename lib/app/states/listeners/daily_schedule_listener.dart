part of 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ScheduleString.dailyScheduleTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ScheduleString.dailyScheduleTag);

  void onArrowBackClick() {
    Get.back(id: ScheduleNavigator.id);
  }

  void onAddButtonClick() {
    Get.toNamed(ScheduleFormCreateView.route, id: ScheduleNavigator.id);
  }

  Color onFindAppointmentColor(Schedule appointment) {
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

  void onEditButtonClick() {
    Get.toNamed(ScheduleFormUpdateView.route, id: ScheduleNavigator.id, arguments: {
      'scheduleId': _properties.selectedAppointment?.scheid,
    });
  }

  void onCalendarTap(CalendarTapDetails details) {
    _properties.selectedAppointment = details.appointments?.first;
  }

  void deleteSchedule() {
    _dataSource.deleteData(_properties.selectedAppointment!.scheid!);
    Get.find<TaskHelper>().loaderPush(_properties.task);
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: () {
          Get.find<DailyScheduleStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
