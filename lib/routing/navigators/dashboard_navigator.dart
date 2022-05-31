// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/core/page_route.dart';
import 'package:ventes/app/states/controllers/contact_state_controller.dart';
import 'package:ventes/app/states/controllers/customer_state_controller.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/resources/views/customer.dart';
import 'package:ventes/app/resources/views/dashboard/dashboard.dart';
import 'package:ventes/core/view_navigator.dart';

class DashboardNavigator extends ViewNavigator {
  static int get id => 1;
  DashboardNavigator({required GlobalKey<NavigatorState> navigatorKey})
      : super(
          navigatorKey: navigatorKey,
        );

  @override
  String get initialRoute => DashboardView.route;

  @override
  Map<String, ViewRoute Function(Map? args)> get routes => {
        DashboardView.route: (args) => ViewRoute(
              page: () => DashboardView(),
              bindings: [
                BindingsBuilder(() {
                  Get.put(DashboardStateController());
                })
              ],
            ),
        CustomerView.route: (args) => ViewRoute(
              page: () => CustomerView(),
              bindings: [
                BindingsBuilder(() {
                  Get.put(CustomerStateController());
                })
              ],
            ),
      };
}
