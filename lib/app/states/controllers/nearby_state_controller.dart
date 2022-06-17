// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/api/presenters/nearby_presenter.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/listeners/nearby_listener.dart';
part 'package:ventes/app/states/data_sources/nearby_data_source.dart';
part 'package:ventes/app/states/properties/nearby_property.dart';

class NearbyStateController extends RegularStateController<NearbyProperty, NearbyListener, NearbyDataSource> {
  @override
  String get tag => NearbyString.nearbyTag;

  @override
  bool get isFixedBody => false;

  @override
  NearbyProperty propertiesBuilder() => NearbyProperty();

  @override
  NearbyListener listenerBuilder() => NearbyListener();

  @override
  NearbyDataSource dataSourceBuilder() => NearbyDataSource();
}
