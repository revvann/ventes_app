import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/daily_schedule_presenter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/data_sources/daily_schedule_data_source.dart';
part 'package:ventes/app/states/listeners/daily_schedule_listener.dart';
part 'package:ventes/app/states/properties/daily_schedule_property.dart';

class DailyScheduleStateController extends RegularStateController<DailyScheduleProperty, DailyScheduleListener, DailyScheduleDataSource> {
  @override
  String get tag => ScheduleString.dailyScheduleTag;

  @override
  bool get isFixedBody => false;

  @override
  DailyScheduleProperty propertiesBuilder() => DailyScheduleProperty();

  @override
  DailyScheduleListener listenerBuilder() => DailyScheduleListener();

  @override
  DailyScheduleDataSource dataSourceBuilder() => DailyScheduleDataSource();
}
