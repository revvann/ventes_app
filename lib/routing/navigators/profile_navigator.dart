// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/profile_state_controller.dart';
import 'package:ventes/app/resources/views/profile/profile.dart';
import 'package:ventes/core/routing/page_route.dart';
import 'package:ventes/core/view/view_navigator.dart';

class ProfileNavigator extends ViewNavigator {
  ProfileNavigator({required GlobalKey<NavigatorState> navigatorKey}) : super(navigatorKey: navigatorKey);

  @override
  String get initialRoute => ProfileView.route;

  @override
  // TODO: implement routes
  Map<String, ViewRoute Function(Map args)> get routes => {
        ProfileView.route: (args) => ViewRoute(
              page: () => ProfileView(),
              binding: BindingsBuilder(() {
                Get.put(ProfileStateController());
              }),
            ),
      };
}
