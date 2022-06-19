import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';

class DailyScheduleListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ScheduleString.dailyScheduleTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ScheduleString.dailyScheduleTag);

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
      'scheduleId': _property.selectedAppointment?.scheid,
    });
  }

  void onCalendarTap(CalendarTapDetails details) {
    _property.selectedAppointment = details.appointments?.first;
  }

  void deleteSchedule() {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ScheduleString.deleteScheduleConfirm,
        onFinished: (res) {
          if (res) {
            _dataSource.deleteData(_property.selectedAppointment!.scheid!);
            Get.find<TaskHelper>().loaderPush(_property.task);
          }
        },
      ),
    );
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<DailyScheduleStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
