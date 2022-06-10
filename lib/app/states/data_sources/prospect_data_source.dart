part of 'package:ventes/app/states/controllers/prospect_state_controller.dart';

class _DataSource extends RegularDataSource<ProspectPresenter> implements FetchDataContract {
  _Listener get _listener => Get.find<_Listener>(tag: ProspectString.prospectTag);

  final Rx<List<KeyableDropdownItem<int, DBType>>> _statusItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set statusItems(List<KeyableDropdownItem<int, DBType>> value) => _statusItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get statusItems => _statusItems.value;

  final Rx<Map<int, String>> _followUpItems = Rx<Map<int, String>>({});
  set followUpItems(Map<int, String> value) => _followUpItems.value = value;
  Map<int, String> get followUpItems => _followUpItems.value;

  final Rx<List<Prospect>> _prospects = Rx<List<Prospect>>([]);
  set prospects(List<Prospect> value) => _prospects.value = value;
  List<Prospect> get prospects => _prospects.value;

  @override
  ProspectPresenter presenterBuilder() => ProspectPresenter();

  void fetchData() => presenter.fetchData();

  void fetchProspect({Map<String, dynamic> params = const {}}) => presenter.fetchProspect(params);

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['statusses'] != null) {
      List<DBType> statusses = List<DBType>.from(data['statusses'].map((e) => DBType.fromJson(e)));
      statusItems = statusses
          .map((e) => KeyableDropdownItem<int, DBType>(
                value: e,
                key: e.typeid!,
              ))
          .toList();
    }

    if (data['followup'] != null) {
      List<DBType> followUp = List<DBType>.from(data['followup'].map((e) => DBType.fromJson(e)));
      followUpItems = followUp.asMap().map<int, String>((i, e) => MapEntry(e.typeid!, e.typename ?? ""));
    }

    if (data['prospects'] != null) {
      prospects = data['prospects'].map<Prospect>((e) => Prospect.fromJson(e)).toList();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.taskCode);
  }
}
