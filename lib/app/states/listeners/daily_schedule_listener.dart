import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/data_sources/daily_schedule_data_source.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

class DailyScheduleListener {
  DailyScheduleProperties get _properties => Get.find<DailyScheduleProperties>();
  DailyScheduleDataSource get _dataSource => Get.find<DailyScheduleDataSource>();

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

  Future onRefresh() async {
    _properties.refresh();
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ScheduleString.dailyScheduleTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ScheduleString.dailyScheduleTaskCode);
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(ScheduleString.dailyScheduleTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ScheduleString.dailyScheduleTaskCode);
  }
}
