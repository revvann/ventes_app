import 'package:ventes/app/api/models/competitor_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/presenters/prospect_competitor_presenter.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';

class ProspectCompetitorDataSource extends StateDataSource<ProspectCompetitorPresenter> with DataSourceMixin {
  final String prospectID = 'prosphdr';
  final String refTypesID = 'reftypehdr';
  final String competitorsID = 'competitorshdr';

  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<List<DBType>, List, Function()> refTypesHandler;
  late DataHandler<List<Competitor>, List, Function(int, int)> competitorsHandler;

  Prospect? get prospect => prospectHandler.value;
  List<DBType> get refTypes => refTypesHandler.value;
  List<Competitor> get competitors => competitorsHandler.value;

  void _refTypesComplete() {
    if (refTypes.isNotEmpty) {
      DBType prospectType = refTypes.firstWhere((element) => element.typename == "Prospect");
      competitorsHandler.fetcher.run(property.prospectid, prospectType.typeid!);
    }
  }

  @override
  void init() {
    super.init();
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson);
    refTypesHandler = Utils.createDataHandler(refTypesID, presenter.fetchRefTypes, [], (data) => data.map<DBType>((e) => DBType.fromJson(e)).toList(), onComplete: _refTypesComplete);
    competitorsHandler = Utils.createDataHandler(competitorsID, presenter.fetchCompetitors, [], (data) => data.map<Competitor>((e) => Competitor.fromJson(e)).toList());
  }

  @override
  ProspectCompetitorPresenter presenterBuilder() => ProspectCompetitorPresenter();
}
