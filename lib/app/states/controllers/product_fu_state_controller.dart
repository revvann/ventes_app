// ignore_for_file: prefer_const_constructors

import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class ProductFormUpdateStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => ProspectString.productUpdateTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => FormSource();
}
