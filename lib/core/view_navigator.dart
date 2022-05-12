// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/core/page_route.dart';

abstract class ViewNavigator extends StatelessWidget {
  ViewNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  String get initialRoute;
  Map<String, ViewRoute Function(Map args)> get routes;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (routeSettings) {
        Map arguments = routeSettings.arguments == null ? {} : routeSettings.arguments as Map;
        if (routes.containsKey(routeSettings.name)) {
          return routes[routeSettings.name]?.call(arguments);
        }
      },
    );
  }
}
