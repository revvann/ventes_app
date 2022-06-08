// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/app/resources/widgets/bottom_navigation.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/routing/navigators/dashboard_navigator.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/routing/navigators/settings_navigator.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';

class MainView extends View<BottomNavigationStateController> {
  static const String route = "/";
  late BottomNavigationStateController state;
  MainView() {
    state = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await state.navigatorKeys[state.currentIndex]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (state.currentIndex != Views.dashboard) {
            state.selectTab(Views.dashboard);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: KeyboardDismissOnTap(
          child: Obx(
            () => Stack(
              children: <Widget>[
                Offstage(
                  offstage: state.currentIndex != Views.dashboard,
                  child: DashboardNavigator(
                    navigatorKey: state.navigatorKeys[Views.dashboard]!,
                  ),
                ),
                Offstage(
                  offstage: state.currentIndex != Views.nearby,
                  child: NearbyNavigator(
                    navigatorKey: state.navigatorKeys[Views.nearby]!,
                  ),
                ),
                Offstage(
                  offstage: state.currentIndex != Views.schedule,
                  child: ScheduleNavigator(
                    navigatorKey: state.navigatorKeys[Views.schedule]!,
                  ),
                ),
                Offstage(
                  offstage: state.currentIndex != Views.prospect,
                  child: ProspectNavigator(
                    navigatorKey: state.navigatorKeys[Views.prospect]!,
                  ),
                ),
                Offstage(
                  offstage: state.currentIndex != Views.settings,
                  child: SettingsNavigator(
                    navigatorKey: state.navigatorKeys[Views.settings]!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
