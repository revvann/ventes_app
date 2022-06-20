import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/prospect_assign_presenter.dart';
import 'package:ventes/app/models/prospect_assign_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/states/typedefs/prospect_assign_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectAssignDataSource extends StateDataSource<ProspectAssignPresenter> with DataSourceMixin implements FetchDataContract {
  final Rx<List<ProspectAssign>> _prospectAssigns = Rx<List<ProspectAssign>>([]);

  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? prospect) => _prospect.value = prospect;

  List<ProspectAssign> get prospectAssigns => _prospectAssigns.value;
  set prospectAssigns(List<ProspectAssign> value) => _prospectAssigns.value = value;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);

  @override
  ProspectAssignPresenter presenterBuilder() => ProspectAssignPresenter();

  @override
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectassigns'] != null) {
      prospectAssigns = data['prospectassigns'].map<ProspectAssign>((e) => ProspectAssign.fromJson(e)).toList();
    }

    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  onLoadComplete() => listener.onComplete();
}
