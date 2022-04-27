// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/state/controllers/settings_state_controller.dart';
import 'package:ventes/app/resources/views/settings.dart';

class SettingsNavigator extends StatelessWidget {
  static const id = 5;
  SettingsNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: SettingsView.route,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == SettingsView.route) {
          return GetPageRoute(
            page: () => SettingsView(),
            binding: BindingsBuilder(() {
              Get.put(SettingsStateController());
            }),
            transition: Transition.fadeIn,
            transitionDuration: Duration(milliseconds: 300),
          );
        }
      },
    );
  }
}
