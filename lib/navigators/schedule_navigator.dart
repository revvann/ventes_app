// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/routes/regular_get_page.dart';
import 'package:ventes/services/user_service.dart';
import 'package:ventes/state_controllers/daily_schedule_state_controller.dart';
import 'package:ventes/state_controllers/fab_state_controller.dart';
import 'package:ventes/state_controllers/schedule_fc_state_controller.dart';
import 'package:ventes/state_controllers/schedule_state_controller.dart';
import 'package:ventes/views/daily_schedule.dart';
import 'package:ventes/views/schedule.dart';
import 'package:ventes/views/schedule_fc.dart';
import 'package:ventes/widgets/regular_dropdown.dart';

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
          return RegularGetRoute(
            page: () => ScheduleView(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => ScheduleStateController());
            }),
          );
        }
        if (routeSettings.name == DailyScheduleView.route) {
          return RegularGetRoute(
            page: () => DailyScheduleView(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => DailyScheduleStateController());
              Get.lazyPut(() => FABStateController());
            }),
          );
        }
        if (routeSettings.name == ScheduleFormCreateView.route) {
          return RegularGetRoute(
            page: () => ScheduleFormCreateView(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => UserService());
              Get.lazyPut(() => ScheduleFormCreateStateController());
            }),
          );
        }
      },
    );
  }
}
