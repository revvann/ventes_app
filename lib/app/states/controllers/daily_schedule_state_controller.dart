import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_form_source.dart';

class DailyScheduleStateController extends StateController<Property, Listener, DataSource, StateFormSource?> {
  @override
  String get tag => ScheduleString.dailyScheduleTag;

  @override
  bool get isFixedBody => false;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  StateFormSource? formSourceBuilder() => null;
}
