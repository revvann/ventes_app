// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/resources/views/chat_home/chat_home.dart';
import 'package:ventes/app/resources/views/chat_room/chat_room.dart';
import 'package:ventes/app/states/controllers/chat_home_state_controller.dart';
import 'package:ventes/app/states/controllers/chat_room_state_controller.dart';
import 'package:ventes/core/routing/page_route.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/resources/views/dashboard/dashboard.dart';
import 'package:ventes/core/view/view_navigator.dart';

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
        ChatHomeView.route: (args) => ViewRoute(
              page: () => ChatHomeView(),
              bindings: [
                BindingsBuilder(() {
                  Get.put(ChatHomeStateController());
                })
              ],
            ),
        ChatRoomView.route: (args) => ViewRoute(
              page: () => ChatRoomView(),
              bindings: [
                BindingsBuilder(() {
                  Get.put(ChatRoomStateController());
                })
              ],
            ),
      };
}
