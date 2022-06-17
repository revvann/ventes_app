// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/notification_helper.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'dart:convert';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/schedule_fc_presenter.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/validators/schedule_fc_validator.dart';
part 'package:ventes/app/states/data_sources/schedule_fc_data_source.dart';
part 'package:ventes/app/states/form/sources/schedule_fc_form_source.dart';
part 'package:ventes/app/states/listeners/schedule_fc_listener.dart';
part 'package:ventes/app/states/properties/schedule_fc_property.dart';

class ScheduleFormCreateStateController extends FormStateController<ScheduleFormCreateProperty, ScheduleFormCreateListener, ScheduleFormCreateDataSource, ScheduleFormCreateFormSource> {
  @override
  String get tag => ScheduleString.scheduleCreateTag;

  @override
  ScheduleFormCreateProperty propertiesBuilder() => ScheduleFormCreateProperty();

  @override
  ScheduleFormCreateListener listenerBuilder() => ScheduleFormCreateListener();

  @override
  ScheduleFormCreateDataSource dataSourceBuilder() => ScheduleFormCreateDataSource();

  @override
  ScheduleFormCreateFormSource formSourceBuilder() => ScheduleFormCreateFormSource();

  @override
  bool get isFixedBody => false;
}
