import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_presenter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDataSource extends StateDataSource<ProspectPresenter> with DataSourceMixin {
  final String statusesID = "stshdr";
  final String prospectsID = 'prshdr';
  final String prospectUpdateID = 'prosupdatehdr';

  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> statusesHandler;
  late DataHandler<List<Prospect>, List, Function([Map<String, dynamic>?])> prospectsHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> prospectUpdateHandler;

  List<KeyableDropdownItem<int, DBType>> get statusItems => statusesHandler.value;
  DBType? get closeWonStatus => statusItems.firstWhereOrNull((e) => e.value.typename == "Closed Won")?.value;
  DBType? get closeLoseStatus => statusItems.firstWhereOrNull((e) => e.value.typename == "Closed Lose")?.value;

  List<Prospect> get prospects => prospectsHandler.value;

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  List<KeyableDropdownItem<int, DBType>> _statusesSuccess(List data) {
    List<DBType> statusses = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    return statusses
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
      initialValue: [],
      fetcher: presenter.fetchStatuses,
      onFailed: (message) => _showFailed(statusesID, message),
      onError: (message) => _showError(statusesID, message),
      onSuccess: _statusesSuccess,
    );

    prospectsHandler = DataHandler(
      prospectsID,
      initialValue: [],
      fetcher: presenter.fetchProspects,
      onFailed: (message) => _showFailed(prospectsID, message),
      onError: (message) => _showError(prospectsID, message),
      onSuccess: (data) => data.map<Prospect>((e) => Prospect.fromJson(e)).toList(),
    );

    prospectUpdateHandler = DataHandler(
      prospectUpdateID,
      initialValue: null,
      fetcher: presenter.updateProspect,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(prospectUpdateID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(prospectUpdateID),
      onFailed: (message) => _showFailed(prospectUpdateID, message, false),
      onError: (message) => _showError(prospectUpdateID, message),
      onSuccess: (message) => Get.find<TaskHelper>().successPush(Task(prospectUpdateID, message: message, onFinished: (res) => Get.find<Controller>().refreshStates())),
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
