import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';

class DailyScheduleProperty extends StateProperty with PropertyMixin {
  Task task = Task(ScheduleString.dailyScheduleTaskCode);
  PopupMenuController popupMenuController = Get.put(PopupMenuController(), tag: "dailyschedulemenupopup");

  final Rx<DateTime> _date = Rx<DateTime>(DateTime.now());
  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = value;

  final Rx<Schedule?> _selectedAppointment = Rx<Schedule?>(null);
  Schedule? get selectedAppointment => _selectedAppointment.value;
  set selectedAppointment(Schedule? value) => _selectedAppointment.value = value;

  void refresh() {
    dataSource.appointmentsHandler.fetcher.run(Utils.dbDateFormat(date));
    dataSource.typesHandler.fetcher.run();
    dataSource.permissionsHandler.fetcher.run();
    dataSource.userHandler.fetcher.run();
  }

  Color getAppointmentColor(Schedule appointment) {
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

  @override
  void close() {
    super.close();
    Get.delete<PopupMenuController>(tag: "dailyschedulemenupopup");
  }
}
