import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';

class ProspectCompetitorFormCreateStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => ProspectString.competitorCreateTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => FormSource();
}
