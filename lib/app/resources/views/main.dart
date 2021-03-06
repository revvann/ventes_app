// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/routing/navigators/dashboard_navigator.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/routing/navigators/profile_navigator.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';

class MainView extends GetView<BottomNavigationStateController> {
  static const String route = "/";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await controller.navigatorKeys[controller.currentIndex]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (controller.currentIndex != Views.dashboard) {
            controller.selectTab(Views.dashboard);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: KeyboardDismissOnTap(
          child: Obx(
            () => Stack(
              children: <Widget>[
                Offstage(
                  offstage: controller.currentIndex != Views.dashboard,
                  child: DashboardNavigator(
                    navigatorKey: controller.navigatorKeys[Views.dashboard]!,
                  ),
                ),
                Offstage(
                  offstage: controller.currentIndex != Views.nearby,
                  child: NearbyNavigator(
                    navigatorKey: controller.navigatorKeys[Views.nearby]!,
                  ),
                ),
                Offstage(
                  offstage: controller.currentIndex != Views.schedule,
                  child: ScheduleNavigator(
                    navigatorKey: controller.navigatorKeys[Views.schedule]!,
                  ),
                ),
                Offstage(
                  offstage: controller.currentIndex != Views.prospect,
                  child: ProspectNavigator(
                    navigatorKey: controller.navigatorKeys[Views.prospect]!,
                  ),
                ),
                Offstage(
                  offstage: controller.currentIndex != Views.profile,
                  child: ProfileNavigator(
                    navigatorKey: controller.navigatorKeys[Views.profile]!,
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
