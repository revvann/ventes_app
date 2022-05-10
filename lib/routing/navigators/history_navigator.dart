// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/state/controllers/history_state_controller.dart';
import 'package:ventes/app/resources/views/history.dart';

class HistoryNavigator extends StatelessWidget {
  static const id = 4;
  HistoryNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: HistoryView.route,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == HistoryView.route) {
          return GetPageRoute(
            page: () => HistoryView(),
            binding: BindingsBuilder(() {
              Get.put(HistoryStateController());
            }),
            transition: Transition.fadeIn,
            transitionDuration: Duration(milliseconds: 300),
          );
        }
      },
    );
  }
}
