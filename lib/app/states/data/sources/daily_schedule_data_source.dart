import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/daily_schedule_presenter.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class DailyScheduleDataSource extends StateDataSource<DailySchedulePresenter> with DataSourceMixin {
  final String typesID = 'typeshdr';
  final String permissionsID = 'permishdr';
  final String schedulesID = 'scheduhdr';
  final String deleteID = 'delhdr';

  late DataHandler<Map<String, int>, List, Function()> typesHandler;
  late DataHandler<List<DBType>, List, Function()> permissionsHandler;
  late DataHandler<List<Schedule>, List, Function(String)> appointmentsHandler;
  late DataHandler<dynamic, String, Function(int)> deleteHandler;

  Map<String, int> get types => typesHandler.value;
  List<Schedule> get appointments => appointmentsHandler.value;
  List<DBType> get permissions => permissionsHandler.value;

  Map<String, int> listToTypes(List types) {
    List<DBType> dbType = List<DBType>.from(types.map((e) => DBType.fromJson(e)).toList());
    return dbType.asMap().map((i, e) => MapEntry(e.typename ?? "", e.typeid ?? 0));
  }

  List<Schedule> listToAppointments(List value) {
    return List<Schedule>.from(value.map((item) => Schedule.fromJson(item)));
  }

  DataHandler<D, R, F> createDataHandler<D, R, F extends Function>(String id, DataFetcher<F, R> fetcher, D initialValue, D Function(R) onSuccess, {Function()? onComplete, Function()? onStart}) {
    return DataHandler<D, R, F>(
      id,
      initialValue: initialValue,
      fetcher: fetcher,
      onFailed: (message) => _showFailed(id, message),
      onError: (message) => _showError(id, message),
      onSuccess: onSuccess,
      onComplete: onComplete,
      onStart: onStart,
    );
  }

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  void _deleteSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(deleteID, message: message, onFinished: (res) {
        Get.find<DailyScheduleStateController>().refreshStates();
      }),
    );
  }

  @override
  void init() {
    super.init();

    typesHandler = createDataHandler(typesID, presenter.fetchTypes, {}, (data) => listToTypes(data));
    permissionsHandler = createDataHandler(permissionsID, presenter.fetchPermission, [], (data) => List<DBType>.from(data.map((e) => DBType.fromJson(e))));

    appointmentsHandler = createDataHandler(
      schedulesID,
      presenter.fetchSchedules,
      [],
      (data) => listToAppointments(data),
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(schedulesID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(schedulesID),
    );

    deleteHandler = DataHandler(
      deleteID,
      fetcher: presenter.delete,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteID)),
      onError: (message) => _showError(deleteID, message),
      onSuccess: _deleteSuccess,
      onFailed: (message) => _showFailed(deleteID, message, false),
      onComplete: () => Get.find<TaskHelper>().loaderPop(deleteID),
    );
  }

  @override
  DailySchedulePresenter presenterBuilder() => DailySchedulePresenter();

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  onLoadError(String message) {}

  @override
  void onDeleteError(String message) {}

  @override
  void onDeleteFailed(String message) {}

  @override
  void onDeleteSuccess(String message) {}

  @override
  void onDeleteComplete() {}

  @override
  onLoadComplete() {}
}
