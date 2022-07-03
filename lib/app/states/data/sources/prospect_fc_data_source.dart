import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_fc_presenter.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormCreateDataSource extends StateDataSource<ProspectFormCreatePresenter> with DataSourceMixin {
  final String statusesID = 'stshdr';
  final String taxesID = 'taxhdr';
  final String stagesID = 'stghdr';
  final String createID = 'createhdr';

  late DataHandler<List<DBType>, List, Function()> statusesHandler;
  late DataHandler<List<DBType>, List, Function()> stagesHandler;
  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> taxesHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> createHandler;

  List<KeyableDropdownItem<int, DBType>> get taxItems => taxesHandler.value;

  Future<List<UserDetail>> fetchUser(String? search) async => await presenter.fetchUsers(search);
  Future<List<BpCustomer>> fetchCustomer(String? search) async => await presenter.fetchCustomers(search);

  List<DBType> _statusesSuccess(data) {
    List<DBType> statusList = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prosstatus = statusList.isEmpty ? null : statusList.first.typeid!;
    return statusList;
  }

  List<DBType> _stagesSuccess(data) {
    List<DBType> stageList = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prosstage = stageList.isEmpty ? null : stageList.first.typeid!;
    return stageList;
  }

  List<KeyableDropdownItem<int, DBType>> _taxesSuccess(data) {
    List<DBType> taxes = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prospectproducttaxdefault = taxes.isNotEmpty ? taxes.first : null;
    return taxes.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
  }

  void _createSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    statusesHandler = Utils.createDataHandler(statusesID, presenter.fetchStatuses, [], _statusesSuccess);
    stagesHandler = Utils.createDataHandler(stagesID, presenter.fetchStages, [], _stagesSuccess);
    taxesHandler = Utils.createDataHandler(taxesID, presenter.fetchTaxes, [], _taxesSuccess);
    createHandler = DataHandler(
      createID,
      fetcher: presenter.create,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onSuccess: _createSuccess,
      onFailed: (message) => Utils.showFailed(createID, message, false),
      onError: (message) => Utils.showError(createID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
    );
  }

  @override
  ProspectFormCreatePresenter presenterBuilder() => ProspectFormCreatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onCreateError(String message) {}

  @override
  void onCreateFailed(String message) {}

  @override
  void onCreateSuccess(String message) {}

  @override
  void onCreateComplete() {}

  @override
  onLoadComplete() {}
}
