import 'package:ventes/app/api/presenters/prospect_assign_presenter.dart';
import 'package:ventes/app/api/models/prospect_assign_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/states/typedefs/prospect_assign_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';

class ProspectAssignDataSource extends StateDataSource<ProspectAssignPresenter> with DataSourceMixin {
  final String prospectID = 'prosphdr';
  final String prospectAssignID = 'prosasshdr';

  late DataHandler<List<ProspectAssign>, List, Function(int)> prospectAssignHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;

  Prospect? get prospect => prospectHandler.value;
  List<ProspectAssign> get prospectAssigns => prospectAssignHandler.value;

  @override
  void init() {
    super.init();
    prospectAssignHandler = Utils.createDataHandler(prospectAssignID, presenter.fetchProspectAssign, [], (data) => data.map<ProspectAssign>((e) => ProspectAssign.fromJson(e)).toList());
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson);
  }

  @override
  ProspectAssignPresenter presenterBuilder() => ProspectAssignPresenter();
}
