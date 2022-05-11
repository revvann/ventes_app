// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/core/page_route.dart';

abstract class ViewNavigator extends StatelessWidget {
  ViewNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  static int get id => 2;
  String get initialRoute;
  Map<String, ViewRoute Function(Object? args)> get routes;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (routeSettings) {
        if (routes.containsKey(routeSettings.name)) {
          return routes[routeSettings.name]?.call(routeSettings.arguments);
        }
      },
    );
  }
}
