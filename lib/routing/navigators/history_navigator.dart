// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/history_state_controller.dart';
import 'package:ventes/app/resources/views/history.dart';
import 'package:ventes/core/page_route.dart';
import 'package:ventes/core/view_navigator.dart';

class HistoryNavigator extends ViewNavigator {
  static const id = 4;
  HistoryNavigator({required GlobalKey<NavigatorState> navigatorKey}) : super(navigatorKey: navigatorKey);

  @override
  String get initialRoute => HistoryView.route;

  @override
  Map<String, ViewRoute Function(Map args)> get routes => {
        HistoryView.route: (args) => ViewRoute(
              page: () => HistoryView(),
              binding: BindingsBuilder(() {
                Get.put(HistoryStateController());
              }),
            ),
      };
}
