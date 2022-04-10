// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/presenters/schedule_fc_presenter.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/views/schedule_form/create/schedule_fc_form_source.dart';
import 'package:ventes/widgets/regular_dropdown.dart';

class ScheduleFormCreateStateController extends RegularStateController {
  ScheduleFormCreatePresenter presenter = ScheduleFormCreatePresenter();
  ScheduleFormCreateSource formSource = ScheduleFormCreateSource();

  final Completer<GoogleMapController> mapsController = Completer();
  late CameraPosition currentPos;

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});

  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;

  @override
  void dispose() {
    formSource.dispose();
    super.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    Position pos = await getCurrentPosition();
    currentPos = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 14.4764);
    presenter.fetchUser();
  }

  @override
  void onReady() {
    super.onReady();
    formSource.ready();
  }
}
