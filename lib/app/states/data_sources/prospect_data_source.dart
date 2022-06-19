import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/prospect_presenter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDataSource extends StateDataSource<ProspectPresenter> implements FetchDataContract {
  Listener get _listener => Get.find<Listener>(tag: ProspectString.prospectTag);
  Property get _property => Get.find<Property>(tag: ProspectString.prospectTag);

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

    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }
}
