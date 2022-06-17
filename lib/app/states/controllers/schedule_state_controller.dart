// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/schedule_presenter.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/listeners/schedule_listener.dart';
part 'package:ventes/app/states/data_sources/schedule_data_source.dart';
part 'package:ventes/app/states/properties/schedule_property.dart';

class ScheduleStateController extends RegularStateController<ScheduleProperty, ScheduleListener, ScheduleDataSource> {
  @override
  String get tag => ScheduleString.scheduleTag;

  @override
  bool get isFixedBody => false;

  @override
  ScheduleProperty propertiesBuilder() => ScheduleProperty();

  @override
  ScheduleListener listenerBuilder() => ScheduleListener();

  @override
  ScheduleDataSource dataSourceBuilder() => ScheduleDataSource();
}
