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

class DailyScheduleListener extends StateListener with ListenerMixin {
  void onArrowBackClick() {
    Get.back(id: ScheduleNavigator.id);
  }

  void onAddButtonClick() {
    Get.toNamed(ScheduleFormCreateView.route, id: ScheduleNavigator.id);
  }

  Color onFindAppointmentColor(Schedule appointment) {
    Color color = RegularColor.primary;
    if (appointment.schetypeid == dataSource.types["Event"]) {
      color = RegularColor.yellow;
    } else if (appointment.schetypeid == dataSource.types["Task"]) {
      color = RegularColor.red;
    } else if (appointment.schetypeid == dataSource.types["Reminder"]) {
      color = RegularColor.cyan;
    }
    return color;
  }

  void onEditButtonClick() {
    Get.toNamed(ScheduleFormUpdateView.route, id: ScheduleNavigator.id, arguments: {
      'scheduleId': property.selectedAppointment?.scheid,
    });
  }

  void onCalendarTap(CalendarTapDetails details) {
    property.selectedAppointment = details.appointments?.first;
  }

  void deleteSchedule() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ScheduleString.deleteScheduleConfirm,
        onFinished: (res) {
          if (res) {
            dataSource.deleteData(property.selectedAppointment!.scheid!);
            Get.find<TaskHelper>().loaderPush(property.task);
          }
        },
      ),
    );
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<DailyScheduleStateController>().refreshStates();
        }));
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.refresh();
  }
}
