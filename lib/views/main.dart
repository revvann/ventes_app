// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/navigators/dashboard_navigator.dart';
import 'package:ventes/navigators/history_navigator.dart';
import 'package:ventes/navigators/nearby_navigator.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/navigators/settings_navigator.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/bottom_navigation.dart';

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
        bottomNavigationBar: BottomNavigation(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            $.currentIndex = Views.schedule;
          },
          splashColor: null,
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RegularColor.primary,
              ),
              child: SvgPicture.asset(
                'assets/svg/plus.svg',
                color: Colors.white,
                width: RegularSize.l,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
