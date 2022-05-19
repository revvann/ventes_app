// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/resources/views/dashboard/dashboard.dart';
import 'package:ventes/app/resources/views/signin/signin.dart';
import 'package:ventes/app/resources/views/started_page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    RouteSettings? routeSettings;
    AuthHelper authHelper = Get.find<AuthHelper>();
    bool isLogin = authHelper.check();

    authHelper.verifyToken().then((value) {
      if (!value) {
        authHelper.retry();
      }
    });

    if (route == DashboardView.route) {
      if (!isLogin) {
        routeSettings = RouteSettings(name: SigninView.route);
      } else {
        routeSettings = null;
      }
    } else if (route == SigninView.route || route == StartedPageView.route) {
      if (isLogin) {
        routeSettings = RouteSettings(name: DashboardView.route);
      } else {
        routeSettings = null;
      }
    }
    return routeSettings;
  }
}
