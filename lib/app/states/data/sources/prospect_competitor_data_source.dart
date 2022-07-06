import 'package:ventes/app/api/presenters/prospect_competitor_presenter.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';

class ProspectCompetitorDataSource extends StateDataSource<ProspectCompetitorPresenter> with DataSourceMixin {
  final String prospectID = 'prosphdr';

  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;

  Prospect? get prospect => prospectHandler.value;

  @override
  void init() {
    super.init();
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson);
  }

  @override
  ProspectCompetitorPresenter presenterBuilder() => ProspectCompetitorPresenter();
}
