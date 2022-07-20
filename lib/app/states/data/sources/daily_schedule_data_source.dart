import 'package:get/get.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/daily_schedule_presenter.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

class DailyScheduleDataSource extends StateDataSource<DailySchedulePresenter> with DataSourceMixin {
  final String typesID = 'typeshdr';
  final String permissionsID = 'permishdr';
  final String schedulesID = 'scheduhdr';
  final String deleteID = 'delhdr';
  final String userID = 'userhdr';
  final String deleteMessageID = 'delmessdhr';

  late DataHandler<Map<String, int>, List, Function()> typesHandler;
  late DataHandler<List<DBType>, List, Function()> permissionsHandler;
  late DataHandler<List<Schedule>, List, Function(String)> appointmentsHandler;
  late DataHandler<dynamic, String, Function(int)> deleteHandler;
  late DataHandler<UserDetail?, Map<String, dynamic>, Function()> userHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> deleteMessageHandler;

  Map<String, int> get types => typesHandler.value;
  List<Schedule> get appointments => appointmentsHandler.value;
  List<DBType> get permissions => permissionsHandler.value;
  UserDetail? get user => userHandler.value;

  Map<String, int> listToTypes(List types) {
    List<DBType> dbType = List<DBType>.from(types.map((e) => DBType.fromJson(e)).toList());
    return dbType.asMap().map((i, e) => MapEntry(e.typename ?? "", e.typeid ?? 0));
  }

  List<Schedule> listToAppointments(List value) {
    return List<Schedule>.from(value.map((item) => Schedule.fromJson(item)));
  }

  void _deleteSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(deleteID, message: message, onFinished: (res) {
        Map<String, dynamic> data = {
          'data': {
            'id': property.selectedAppointment!.scheid.toString(),
          },
          "token": user?.user?.userfcmtoken,
        };
        deleteMessageHandler.fetcher.run(data);
      }),
    );
  }

  void deleteMessageComplete() {
    Get.find<DailyScheduleStateController>().refreshStates();
    Get.find<TaskHelper>().loaderPop(deleteMessageID);
  }

  @override
  void init() {
    super.init();

    typesHandler = Utils.createDataHandler(typesID, presenter.fetchTypes, {}, (data) => listToTypes(data));
    permissionsHandler = Utils.createDataHandler(permissionsID, presenter.fetchPermission, [], (data) => List<DBType>.from(data.map((e) => DBType.fromJson(e))));

    appointmentsHandler = Utils.createDataHandler(
      schedulesID,
      presenter.fetchSchedules,
      [],
      (data) => listToAppointments(data),
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(schedulesID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(schedulesID),
    );

    userHandler = DataHandler(
      userID,
      fetcher: presenter.fetchUserDetail,
      initialValue: null,
      onError: (message) => Utils.showError(userID, message),
      onFailed: (message) => Utils.showFailed(userID, message),
      onSuccess: UserDetail.fromJson,
    );

    deleteHandler = DataHandler(
      deleteID,
      fetcher: presenter.delete,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteID)),
      onError: (message) => Utils.showError(deleteID, message),
      onSuccess: _deleteSuccess,
      onFailed: (message) => Utils.showFailed(deleteID, message, false),
      onComplete: () => Get.find<TaskHelper>().loaderPop(deleteID),
    );

    deleteMessageHandler = DataHandler(
      deleteMessageID,
      fetcher: presenter.deleteMessage,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteMessageID)),
      onComplete: deleteMessageComplete,
      onError: (message) => Utils.showError(deleteMessageID, message),
      onFailed: (message) => Utils.showFailed(deleteMessageID, message),
      onSuccess: (data) {},
    );
  }

  @override
  DailySchedulePresenter presenterBuilder() => DailySchedulePresenter();
}
