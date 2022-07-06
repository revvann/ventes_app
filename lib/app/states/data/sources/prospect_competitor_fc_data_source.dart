import 'package:ventes/app/api/presenters/prospect_competitor_fc_presenter.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';

class ProspectCompetitorFormCreateDataSource extends StateDataSource<ProspectCompetitorFormCreatePresenter> with DataSourceMixin {
  @override
  ProspectCompetitorFormCreatePresenter presenterBuilder() => ProspectCompetitorFormCreatePresenter();
}
