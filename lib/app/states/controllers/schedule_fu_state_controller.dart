// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/schedule_fu_presenter.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

import 'dart:convert';

import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/validators/schedule_fu_validator.dart';
part 'package:ventes/app/states/data_sources/schedule_fu_data_source.dart';
part 'package:ventes/app/states/form/sources/schedule_fu_form_source.dart';
part 'package:ventes/app/states/listeners/schedule_fu_listener.dart';
part 'package:ventes/app/states/properties/schedule_fu_property.dart';

class ScheduleFormUpdateStateController extends FormStateController<ScheduleFormUpdateProperty, ScheduleFormUpdateListener, ScheduleFormUpdateDataSource, ScheduleFormUpdateFormSource> {
  @override
  String get tag => ScheduleString.scheduleUpdateTag;

  @override
  ScheduleFormUpdateProperty propertiesBuilder() => ScheduleFormUpdateProperty();

  @override
  ScheduleFormUpdateListener listenerBuilder() => ScheduleFormUpdateListener();

  @override
  ScheduleFormUpdateDataSource dataSourceBuilder() => ScheduleFormUpdateDataSource();

  @override
  ScheduleFormUpdateFormSource formSourceBuilder() => ScheduleFormUpdateFormSource();
}
