import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_fu_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_fu_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectFormUpdateDataSource extends StateDataSource<ProspectFormUpdatePresenter> with DataSourceMixin {
  final String stagesID = 'stgshdr';
  final String statusesID = 'ststshdr';
  final String prospectID = 'proshdr';
  final String updateID = 'updatehd';

  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> stagesHandler;
  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> statusesHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> updateHandler;

  Prospect? get prospect => prospectHandler.value;

  Future<List<UserDetail>> fetchUser(String? search) async => await presenter.fetchUsers(search);
  Future<List<BpCustomer>> fetchCustomer(String? search) async => await presenter.fetchCustomers(search);

  List<KeyableDropdownItem<int, DBType>> _stagesSuccess(data) {
    List<DBType> stageList = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prosstage = stageList.isEmpty ? null : stageList.first;
    return stageList.map<KeyableDropdownItem<int, DBType>>((type) => KeyableDropdownItem<int, DBType>(key: type.typeid!, value: type)).toList();
  }

  List<KeyableDropdownItem<int, DBType>> _statusesSuccess(data) {
    List<DBType> statusList = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    statusList.removeWhere((element) => element.typename?.contains(RegExp(r'Closed Won|Closed Lose')) ?? false);
    formSource.prosstatus = statusList.isEmpty ? null : statusList.first;
    return statusList.map<KeyableDropdownItem<int, DBType>>((type) => KeyableDropdownItem<int, DBType>(key: type.typeid!, value: type)).toList();
  }

  void updateSuccess(String message) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectStateController>().refreshStates();
          Get.back(id: ProspectNavigator.id);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    stagesHandler = createDataHandler(stagesID, presenter.fetchStage, [], _stagesSuccess);
    statusesHandler = createDataHandler(statusesID, presenter.fetchStatuses, [], _statusesSuccess);
    prospectHandler = createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson, onComplete: () => formSource.prepareFormValues());
    updateHandler = DataHandler(
      updateID,
      fetcher: presenter.update,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(updateID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(updateID),
      onFailed: (message) => Get.find<TaskHelper>().failedPush(Task(updateID, message: message)),
      onError: (message) => Get.find<TaskHelper>().errorPush(Task(updateID, message: message)),
      onSuccess: updateSuccess,
    );
  }

  @override
  ProspectFormUpdatePresenter presenterBuilder() => ProspectFormUpdatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onUpdateError(String message) {}

  @override
  void onUpdateFailed(String message) {}

  @override
  void onUpdateSuccess(String message) {}

  @override
  onLoadComplete() {}

  @override
  void onUpdateComplete() {}
}
