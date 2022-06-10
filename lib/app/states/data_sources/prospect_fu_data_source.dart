part of 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';

class _DataSource extends RegularDataSource<ProspectFormUpdatePresenter> implements ProspectUpdateContract {
  _Listener get _listener => Get.find<_Listener>(tag: ProspectString.prospectUpdateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.prospectUpdateTag);

  final Rx<Map<int, String>> _followUpItems = Rx<Map<int, String>>({});
  set followUpItems(Map<int, String> value) => _followUpItems.value = value;
  Map<int, String> get followUpItems => _followUpItems.value;

  Prospect? prospect;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);
  Future<List<UserDetail>> fetchUser(String? search) async => await presenter.fetchUsers(search);
  Future<List<BpCustomer>> fetchCustomer(String? search) async => await presenter.fetchCustomers(search);
  void updateProspect(int prospectid, Map<String, dynamic> data) => presenter.updateProspect(prospectid, data);

  @override
  ProspectFormUpdatePresenter presenterBuilder() => ProspectFormUpdatePresenter();

  @override
  onLoadError(String message) => _listener.onDataLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onDataLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['followup'] != null) {
      List<DBType> followUpList = data['followup'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prostype = followUpList.isEmpty ? null : followUpList.first.typeid!;
      followUpItems = followUpList.asMap().map((index, item) => MapEntry(item.typeid!, item.typename!));
    }

    if (data['status'] != null) {
      List<DBType> statusList = data['status'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosstatus = statusList.isEmpty ? null : statusList.first.typeid!;
    }

    if (data['stage'] != null) {
      List<DBType> stageList = data['stage'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosstage = stageList.isEmpty ? null : stageList.first.typeid!;
    }

    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
      _formSource.prepareFormValues();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
