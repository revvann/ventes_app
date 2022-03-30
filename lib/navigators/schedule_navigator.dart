// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/state_controllers/daily_schedule_state_controller.dart';
import 'package:ventes/state_controllers/fab_state_controller.dart';
import 'package:ventes/state_controllers/schedule_state_controller.dart';
import 'package:ventes/views/daily_schedule.dart';
import 'package:ventes/views/schedule.dart';

class ScheduleNavigator extends StatelessWidget {
  static const id = 3;
  ScheduleNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: ScheduleView.route,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == ScheduleView.route) {
          return GetPageRoute(
            page: () => ScheduleView(),
            binding: BindingsBuilder(() {
              Get.put(ScheduleStateController());
            }),
            transition: Transition.fadeIn,
            transitionDuration: Duration(milliseconds: 300),
          );
        }
        if (routeSettings.name == DailyScheduleView.route) {
          return GetPageRoute(
            page: () => DailyScheduleView(),
            binding: BindingsBuilder(() {
              Get.put(DailyScheduleStateController());
              Get.put(FABStateController());
            }),
            transition: Transition.fadeIn,
            transitionDuration: Duration(milliseconds: 300),
          );
        }
      },
    );
  }
}
