// ignore_for_file: prefer_const_constructors

import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_fu_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class ScheduleFormUpdateStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => ScheduleString.scheduleUpdateTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => FormSource();

  @override
  bool get isFixedBody => false;
}
