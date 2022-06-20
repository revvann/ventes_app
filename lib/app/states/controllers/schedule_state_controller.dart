// ignore_for_file: prefer_const_constructors
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class ScheduleStateController extends StateController<Property, Listener, DataSource, FormSource?> {
  @override
  String get tag => ScheduleString.scheduleTag;

  @override
  bool get isFixedBody => false;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource? formSourceBuilder() => null;
}
