import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/prospect_presenter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDataSource extends StateDataSource<ProspectPresenter> with DataSourceMixin implements FetchDataContract {
  final String statusesID = "stshdr";
  final String prospectsID = 'prshdr';

  late DataHandler<List, Function()> statusesHandler;
  late DataHandler<List, Function([Map<String, dynamic>?])> prospectsHandler;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _statusItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set statusItems(List<KeyableDropdownItem<int, DBType>> value) => _statusItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get statusItems => _statusItems.value;

  final Rx<List<Prospect>> _prospects = Rx<List<Prospect>>([]);
  set prospects(List<Prospect> value) => _prospects.value = value;
  List<Prospect> get prospects => _prospects.value;

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  void _statusesSuccess(List data) {
    List<DBType> statusses = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    statusItems = statusses
        .map((e) => KeyableDropdownItem<int, DBType>(
              value: e,
              key: e.typeid!,
            ))
        .toList();
  }

  @override
  void init() {
    super.init();

    statusesHandler = DataHandler(
      statusesID,
      fetcher: presenter.fetchStatuses,
      onFailed: (message) => _showFailed(statusesID, message),
      onError: (message) => _showError(statusesID, message),
      onSuccess: _statusesSuccess,
    );

    prospectsHandler = DataHandler(
      prospectsID,
      fetcher: presenter.fetchProspects,
      onFailed: (message) => _showFailed(prospectsID, message),
      onError: (message) => _showError(prospectsID, message),
      onSuccess: (data) => prospects = data.map<Prospect>((e) => Prospect.fromJson(e)).toList(),
    );
  }

  @override
  ProspectPresenter presenterBuilder() => ProspectPresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  onLoadComplete() {}
}
