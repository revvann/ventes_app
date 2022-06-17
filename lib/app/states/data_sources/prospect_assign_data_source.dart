part of 'package:ventes/app/states/controllers/prospect_assign_state_controller.dart';

class ProspectAssignDataSource extends StateDataSource<ProspectAssignPresenter> implements FetchDataContract {
  ProspectAssignListener get _listener => Get.find<ProspectAssignListener>(tag: ProspectString.prospectAssignTag);
  ProspectAssignProperty get _properties => Get.find<ProspectAssignProperty>(tag: ProspectString.prospectAssignTag);

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
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectassigns'] != null) {
      prospectAssigns = data['prospectassigns'].map<ProspectAssign>((e) => ProspectAssign.fromJson(e)).toList();
    }

    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }
}
