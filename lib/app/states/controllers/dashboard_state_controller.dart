// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/dashboard_data_source.dart';
import 'package:ventes/app/states/listeners/dashboard_listener.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardStateController extends RegularStateController {
  BottomNavigationStateController bottomNavigation = Get.put(BottomNavigationStateController());
  DashboardDataSource dataSource = Get.put(DashboardDataSource());
  DashboardListener listener = Get.put(DashboardListener());
  DashboardProperties properties = Get.put(DashboardProperties());

  @override
  void onInit() async {
    super.onInit();
    properties.refresh();
    dataSource.init();
  }

  @override
  void onClose() {
    Get.delete<DashboardProperties>();
    Get.delete<DashboardListener>();
    Get.delete<DashboardDataSource>();
    super.onClose();
  }
}

class DashboardProperties {
  final DashboardDataSource _dataSource = Get.find<DashboardDataSource>();
  Position? position;

  void refresh() async {
    position = await getCurrentPosition();
    _dataSource.fetchData(LatLng(position!.latitude, position!.longitude));
    Get.find<TaskHelper>().add(DashboardString.taskCode);
  }

  void logout() async {
    _dataSource.logout();
    Get.find<TaskHelper>().add(DashboardString.taskCode);
  }
}

enum CameraMoveType { dragged, controller }
