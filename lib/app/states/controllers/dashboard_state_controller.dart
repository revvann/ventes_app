// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class DashboardStateController extends StateController<Property, Listener, DataSource, FormSource> {
  BottomNavigationStateController bottomNavigation = Get.put(BottomNavigationStateController());

  @override
  String get tag => DashboardString.dashboardTag;

  @override
  bool get isFixedBody => false;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => null;
}
