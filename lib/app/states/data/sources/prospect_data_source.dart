import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_presenter.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

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
      onFailed: (message) => Utils.showFailed(statusesID, message),
      onError: (message) => Utils.showError(statusesID, message),
      onSuccess: _statusesSuccess,
    );

    prospectsHandler = DataHandler(
      prospectsID,
      initialValue: [],
      fetcher: presenter.fetchProspects,
      onFailed: (message) => Utils.showFailed(prospectsID, message),
      onError: (message) => Utils.showError(prospectsID, message),
      onSuccess: (data) => data.map<Prospect>((e) => Prospect.fromJson(e)).toList(),
    );

    prospectUpdateHandler = DataHandler(
      prospectUpdateID,
      initialValue: null,
      fetcher: presenter.updateProspect,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(prospectUpdateID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(prospectUpdateID),
      onFailed: (message) => Utils.showFailed(prospectUpdateID, message, false),
      onError: (message) => Utils.showError(prospectUpdateID, message),
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
