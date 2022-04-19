// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/app/resources/widgets/bottom_navigation.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/routing/navigators/dashboard_navigator.dart';
import 'package:ventes/routing/navigators/history_navigator.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/routing/navigators/settings_navigator.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';

class MainView extends RegularView<BottomNavigationStateController> {
  static const String route = "/";
  late BottomNavigationStateController $;
  MainView() {
    $ = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await $.navigatorKeys[$.currentIndex]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if ($.currentIndex != Views.dashboard) {
            $.selectTab(Views.dashboard);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Obx(
          () => Stack(
            children: <Widget>[
              Offstage(
                offstage: $.currentIndex != Views.dashboard,
                child: DashboardNavigator(
                  navigatorKey: $.navigatorKeys[Views.dashboard]!,
                ),
              ),
              Offstage(
                offstage: $.currentIndex != Views.nearby,
                child: NearbyNavigator(
                  navigatorKey: $.navigatorKeys[Views.nearby]!,
                ),
              ),
              Offstage(
                offstage: $.currentIndex != Views.schedule,
                child: ScheduleNavigator(
                  navigatorKey: $.navigatorKeys[Views.schedule]!,
                ),
              ),
              Offstage(
                offstage: $.currentIndex != Views.history,
                child: HistoryNavigator(
                  navigatorKey: $.navigatorKeys[Views.history]!,
                ),
              ),
              Offstage(
                offstage: $.currentIndex != Views.settings,
                child: SettingsNavigator(
                  navigatorKey: $.navigatorKeys[Views.settings]!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
