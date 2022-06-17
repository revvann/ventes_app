import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/daily_schedule_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

part 'package:ventes/app/states/data_sources/daily_schedule_data_source.dart';
part 'package:ventes/app/states/listeners/daily_schedule_listener.dart';

class DailyScheduleStateController extends RegularStateController<_Properties, _Listener, _DataSource> {
  @override
  String get tag => ScheduleString.dailyScheduleTag;

  @override
  bool get isFixedBody => false;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ScheduleString.dailyScheduleTag);

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
