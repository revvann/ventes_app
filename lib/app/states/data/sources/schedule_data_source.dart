// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/schedule_presenter.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/states/typedefs/schedule_typedef.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

class ScheduleDataSource extends StateDataSource<SchedulePresenter> with DataSourceMixin {
  final String typesID = 'typeshdr';
  final String permissionsID = 'permishdr';
  final String schedulesID = 'scheduhdr';

  late DataHandler<Map<String, int>, List, Function()> typesHandler;
  late DataHandler<List<DBType>, List, Function()> permissionsHandler;
  late DataHandler<List<Schedule>, List, Function([int?])> appointmentsHandler;

  Map<String, int> get types => typesHandler.value;
  List<DBType> get permissions => permissionsHandler.value;
  List<Schedule> get appointments => appointmentsHandler.value;

  Map<String, int> listToTypes(List types) {
    List<DBType> dbType = List<DBType>.from(types.map((e) => DBType.fromJson(e)).toList());
    return dbType.asMap().map((i, e) => MapEntry(e.typename ?? "", e.typeid ?? 0));
  }

  List<Schedule> listToAppointments(List value) {
    return List<Schedule>.from(value.map((item) => Schedule.fromJson(item)));
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
  }

  @override
  SchedulePresenter presenterBuilder() => SchedulePresenter();
}
