import 'package:ventes/constants/views.dart';

class RoutePack {
  Views menu;
  String route;
  Map<String, dynamic>? arguments;

  RoutePack(this.menu, this.route, {this.arguments});
}
