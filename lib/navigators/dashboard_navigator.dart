// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/routes/regular_get_page.dart';
import 'package:ventes/state_controllers/dashboard_state_controller.dart';
import 'package:ventes/views/dashboard.dart';

class DashboardNavigator extends StatelessWidget {
  static const id = 1;
  DashboardNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: DashboardView.route,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == DashboardView.route) {
          return RegularGetRoute(
            page: () => DashboardView(),
            bindings: [
              BindingsBuilder(() {
                Get.put(DashboardStateController());
              })
            ],
          );
        }
      },
    );
  }
}
