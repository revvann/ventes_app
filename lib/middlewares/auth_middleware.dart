// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/views/main.dart';
import 'package:ventes/views/signin.dart';
import 'package:ventes/views/started_page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    RouteSettings? routeSettings;
    bool isLogin = Get.find<AuthHelper>().check();
    if (route == MainView.route) {
      if (!isLogin) {
        routeSettings = RouteSettings(name: SigninView.route);
      } else {
        routeSettings = null;
      }
    } else if (route == SigninView.route) {
      if (isLogin) {
        routeSettings = RouteSettings(name: MainView.route);
      } else {
        routeSettings = null;
      }
    } else if (route == StartedPageView.route) {
      if (isLogin) {
        routeSettings = RouteSettings(name: MainView.route);
      } else {
        routeSettings = null;
      }
    }
    return routeSettings;
  }
}
