// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/schedule_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

part 'package:ventes/app/states/listeners/schedule_listener.dart';
part 'package:ventes/app/states/data_sources/schedule_data_source.dart';

class ScheduleStateController extends RegularStateController<_Properties, _Listener, _DataSource> {
  @override
  String get tag => ScheduleString.scheduleTag;

  @override
  bool get isFixedBody => false;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  void ready() {
    super.ready();
    properties.ready();
  }

  @override
  void close() {
    super.close();
    properties.calendarController.dispose();
  }
}

class _Properties {
  _Listener get _listener => Get.find<_Listener>(tag: ScheduleString.scheduleTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ScheduleString.scheduleTag);

  final CalendarController calendarController = CalendarController();

  Task task = Task(ScheduleString.taskCode);

  final _dateShown = DateTime.now().obs;
  DateTime get dateShown => _dateShown.value;
  set dateShown(DateTime value) => _dateShown.value = value;

  final _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;
  set selectedDate(DateTime value) => _selectedDate.value = value;

  DateTime initialDate = DateTime.now();

  void ready() {
    DateTime now = DateTime.now();

    selectedDate = DateTime(now.year, now.month, now.day);
    dateShown = calendarController.displayDate ?? now;
    initialDate = dateShown;

    calendarController.addPropertyChangedListener(_listener.onDateShownChanged);
    refresh();
  }

  void refresh() {
    _dataSource.fetchData(dateShown.month);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
