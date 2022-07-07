import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ProspectCompetitorFormCreateProperty extends StateProperty with PropertyMixin {
  late int prospectid;

  void refresh() {
    dataSource.refTypesHandler.fetcher.run();
    dataSource.prospectHandler.fetcher.run(prospectid);
  }
}
