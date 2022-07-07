import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';

class ProspectCompetitorFormUpdateStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  String get tag => ProspectString.competitorUpdateTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource formSourceBuilder() => FormSource();
}
