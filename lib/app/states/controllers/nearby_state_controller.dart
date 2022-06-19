// ignore_for_file: prefer_const_constructors

import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class NearbyStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => NearbyString.nearbyTag;

  @override
  bool get isFixedBody => false;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => null;
}
