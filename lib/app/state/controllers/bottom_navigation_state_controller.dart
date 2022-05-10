import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/routing/navigators/dashboard_navigator.dart';
import 'package:ventes/routing/navigators/history_navigator.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/routing/navigators/settings_navigator.dart';
import 'package:ventes/app/state/controllers/regular_state_controller.dart';

class BottomNavigationStateController extends RegularStateController {
  @override
  get isFixedBody => false;

  final _currentIndex = Views.dashboard.obs;

  final _navigatorKeys = {
    Views.dashboard: Get.nestedKey(DashboardNavigator.id),
    Views.nearby: Get.nestedKey(NearbyNavigator.id),
    Views.schedule: Get.nestedKey(ScheduleNavigator.id),
    Views.history: Get.nestedKey(HistoryNavigator.id),
    Views.settings: Get.nestedKey(SettingsNavigator.id),
  };

  void selectTab(Views tabItem) {
    if (tabItem == _currentIndex.value) {
      Get.until((route) => route.isFirst);
    } else {
      _currentIndex.value = tabItem;
    }
  }

  Views get currentIndex => _currentIndex.value;
  set currentIndex(Views value) => _currentIndex.value = value;
  Map<Views, GlobalKey<NavigatorState>?> get navigatorKeys => _navigatorKeys;
}
