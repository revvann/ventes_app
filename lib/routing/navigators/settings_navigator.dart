// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/settings_state_controller.dart';
import 'package:ventes/app/resources/views/settings.dart';
import 'package:ventes/core/routing/page_route.dart';
import 'package:ventes/core/view/view_navigator.dart';

class SettingsNavigator extends ViewNavigator {
  static const id = 5;
  SettingsNavigator({required GlobalKey<NavigatorState> navigatorKey}) : super(navigatorKey: navigatorKey);

  @override
  String get initialRoute => SettingsView.route;

  @override
  // TODO: implement routes
  Map<String, ViewRoute Function(Map args)> get routes => {
        SettingsView.route: (args) => ViewRoute(
              page: () => SettingsView(),
              binding: BindingsBuilder(() {
                Get.put(SettingsStateController());
              }),
            ),
      };
}
