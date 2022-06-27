import 'package:ventes/app/states/typedefs/prospect_dashboard_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_controller.dart';

class ProspectDashboardStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => ProspectString.prospectDashboardTag;

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource? formSourceBuilder() => null;

  @override
  Listener listenerBuilder() => Listener();

  @override
  Property propertyBuilder() => Property();

  @override
  bool get isFixedBody => false;
}
