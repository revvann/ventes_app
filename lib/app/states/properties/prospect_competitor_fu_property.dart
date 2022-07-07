import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ProspectCompetitorFormUpdateProperty extends StateProperty with PropertyMixin {
  late int competitorid;

  void refresh() {
    dataSource.competitorHandler.fetcher.run(competitorid);
  }
}
