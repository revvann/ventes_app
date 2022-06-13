part of 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';

class _DataSource extends RegularDataSource<ProspectDetailPresenter> implements FetchDataContract {
  _Listener get _listener => Get.find<_Listener>(tag: ProspectString.detailTag);

  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? value) => _prospect.value = value;

  final _prospectDetails = Rx<List<ProspectDetail>>([]);
  List<ProspectDetail> get prospectDetails => _prospectDetails.value;
  set prospectDetails(List<ProspectDetail> value) => _prospectDetails.value = value;

  final _stages = Rx<List<DBType>>([]);
  List<DBType> get stages => _stages.value;
  set stages(List<DBType> value) => _stages.value = value;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);

  @override
  ProspectDetailPresenter presenterBuilder() => ProspectDetailPresenter();

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectdetails'] != null) {
      prospectDetails = data['prospectdetails'].map<ProspectDetail>((json) => ProspectDetail.fromJson(json)).toList();
    }

    if (data['stages'] != null) {
      stages = data['stages'].map<DBType>((json) => DBType.fromJson(json)).toList();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.detailTaskCode);
  }
}
