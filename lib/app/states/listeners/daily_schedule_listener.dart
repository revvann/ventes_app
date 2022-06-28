import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
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
    Get.toNamed(
      ScheduleFormCreateView.route,
      id: ScheduleNavigator.id,
      arguments: {
        'startDate': property.date,
      },
    );
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
    property.popupMenuController.toggleDropdown(close: true);
    Get.toNamed(ScheduleFormUpdateView.route, id: ScheduleNavigator.id, arguments: {
      'scheduleId': property.selectedAppointment?.scheid,
    });
  }

  void onCalendarTap(CalendarTapDetails details) {
    property.selectedAppointment = details.appointments?.first;
  }

  void deleteSchedule() {
    property.popupMenuController.toggleDropdown(close: true);
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ScheduleString.deleteScheduleConfirm,
        onFinished: (res) {
          if (res) {
            dataSource.deleteHandler.fetcher.run(property.selectedAppointment!.scheid!);
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
