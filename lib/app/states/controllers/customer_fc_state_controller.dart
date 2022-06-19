// ignore_for_file: prefer_const_constructors

import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class CustomerFormCreateStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => NearbyString.customerCreateTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => FormSource();
}
