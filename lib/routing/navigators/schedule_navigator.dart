// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/network/services/schedule_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';
import 'package:ventes/core/page_route.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/schedule_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/schedule_state_controller.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/app/resources/views/schedule/schedule.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';

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
        Map arguments = routeSettings.arguments == null ? {} : routeSettings.arguments as Map;
        if (routeSettings.name == ScheduleView.route) {
          return ViewRoute(
            page: () => ScheduleView(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => ScheduleService());
              Get.lazyPut(() => TypeService());
              Get.lazyPut(() => ScheduleStateController());
            }),
          );
        }
        if (routeSettings.name == DailyScheduleView.route) {
          return ViewRoute(
            page: () => DailyScheduleView(
              date: arguments["date"],
            ),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => TypeService());
              Get.lazyPut(() => ScheduleService());
              Get.lazyPut(() => DailyScheduleStateController());
            }),
          );
        }
        if (routeSettings.name == ScheduleFormCreateView.route) {
          return ViewRoute(
            page: () => ScheduleFormCreateView(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => UserService());
              Get.lazyPut(() => TypeService());
              Get.lazyPut(() => ScheduleService());
              Get.lazyPut(() => ScheduleFormCreateStateController());
            }),
          );
        }
        if (routeSettings.name == ScheduleFormUpdateView.route) {
          return ViewRoute(
            page: () => ScheduleFormUpdateView(
              scheduleId: arguments['scheduleId'],
            ),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => UserService());
              Get.lazyPut(() => TypeService());
              Get.lazyPut(() => ScheduleService());
              Get.lazyPut(() => ScheduleFormUpdateStateController());
            }),
          );
        }
      },
    );
  }
}
