// ignore_for_file: prefer_const_constructors

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/dashboard_presenter.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/listeners/dashboard_listener.dart';
part 'package:ventes/app/states/data_sources/dashboard_data_source.dart';
part 'package:ventes/app/states/properties/dashboard_property.dart';

class DashboardStateController extends RegularStateController<DashboardProperty, DashboardListener, DashboardDataSource> {
  BottomNavigationStateController bottomNavigation = Get.put(BottomNavigationStateController());

  @override
  String get tag => DashboardString.dashboardTag;

  @override
  bool get isFixedBody => false;

  @override
  DashboardProperty propertiesBuilder() => DashboardProperty();

  @override
  DashboardListener listenerBuilder() => DashboardListener();

  @override
  DashboardDataSource dataSourceBuilder() => DashboardDataSource();
}
