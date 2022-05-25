import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/listeners/prospect_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDataSource implements FetchDataContract {
  ProspectListener get _listener => Get.find<ProspectListener>();

  final ProspectPresenter _presenter = ProspectPresenter();

  final Rx<List<DropdownItem<int, DBType>>> _statusItems = Rx<List<DropdownItem<int, DBType>>>([]);
  set statusItems(List<DropdownItem<int, DBType>> value) => _statusItems.value = value;
  List<DropdownItem<int, DBType>> get statusItems => _statusItems.value;

  final Rx<Map<int, String>> _followUpItems = Rx<Map<int, String>>({});
  set followUpItems(Map<int, String> value) => _followUpItems.value = value;
  Map<int, String> get followUpItems => _followUpItems.value;

  final Rx<List<Prospect>> _prospects = Rx<List<Prospect>>([]);
  set prospects(List<Prospect> value) => _prospects.value = value;
  List<Prospect> get prospects => _prospects.value;

  init() {
    _presenter.fetchContract = this;
  }

  reset() {
    _prospects.value = [];
    _statusItems.value = [];
    _followUpItems.value = {};
  }

  void fetchData() => _presenter.fetchData();

  void fetchProspect({Map<String, dynamic> params = const {}}) => _presenter.fetchProspect(params);

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['statusses'] != null) {
      List<DBType> statusses = List<DBType>.from(data['statusses'].map((e) => DBType.fromJson(e)));
      statusItems = statusses
          .map((e) => DropdownItem<int, DBType>(
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
