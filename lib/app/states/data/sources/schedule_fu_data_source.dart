import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/schedule_fu_presenter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/typedefs/schedule_fu_typedef.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormUpdateDataSource extends StateDataSource<ScheduleFormUpdatePresenter> with DataSourceMixin {
  final String typesID = 'typshdr';
  final String scheduleID = 'schehdr';
  final String updateID = 'updatehdr';

  late DataHandler<List<Map<String, int>>, List, Function()> typesHandler;
  late DataHandler<Schedule?, Map<String, dynamic>, Function(int)> scheduleHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> updateHandler;

  late int scheduleId;

  List<Map<String, int>> get types => typesHandler.value;

  String? typeName(int index) => types.isNotEmpty ? types[index].keys.first : null;
  List<String> typeNames() => types.map((type) => type.keys.first).toList();
  int? typeId(int index) => types.isNotEmpty ? types[index].values.first : null;
  List<int> typeIds() => types.map((type) => type.values.first).toList();
  int typeIndex(int id) => typeIds().isNotEmpty ? typeIds().indexOf(id) : -1;

  Schedule? get schedule => scheduleHandler.value;

  List<Map<String, int>> insertTypes(List types) {
    List<DBType> typeMap = types.map((type) => DBType.fromJson(type)).where((element) => element.typeid == schedule?.schetypeid).toList();
    return typeMap.map((type) => {type.typename ?? "": type.typeid ?? 0}).toList();
  }

  Future<UserDetail> get userActive async => (await presenter.findActiveUser())!;

  Future<List<UserDetail>> filterUser(String? search) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    List<UserDetail> userDetails = await presenter.fetchUsers(search);

    userDetails = userDetails.where((e) => e.userdtid != authModel?.accountActive).toList();
    return distinct(userDetails);
  }

  Future<List<UserDetail>> allUser(String? search) async {
    List<UserDetail> userDetails = await presenter.fetchUsers(search);
    return distinct(userDetails);
  }

  List<UserDetail> distinct(List<UserDetail> userDetails) {
    Map<int, int> userIds = userDetails.asMap().map((k, v) => MapEntry(v.userid ?? 0, v.userdtid ?? 0));
    userDetails = userDetails.where((e) {
      bool isExist = userIds.containsKey(e.userid);
      int userdtid = userIds[e.userid] ?? 0;
      return isExist && e.userdtid == userdtid;
    }).toList();
    return userDetails;
  }

  void _updateSuccess(data) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: ScheduleString.updateSuccess,
        onFinished: (res) {
          Get.find<DailyScheduleStateController>().refreshStates();
          Get.back(id: Views.schedule.index);
        },
      ),
    );
  }

  void _scheduleComplete() {
    typesHandler.fetcher.run();
  }

  @override
  void init() {
    super.init();
    typesHandler = createDataHandler(
      typesID,
      presenter.fetchTypes,
      [],
      insertTypes,
      onComplete: () => formSource.prepareFormValues(),
    );
    scheduleHandler = createDataHandler(scheduleID, presenter.fetchSchedule, null, Schedule.fromJson, onComplete: _scheduleComplete);
    updateHandler = DataHandler(
      updateID,
      fetcher: presenter.update,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(updateID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(updateID),
      onError: (message) => showError(updateID, message),
      onFailed: (message) => showFailed(updateID, message),
      onSuccess: _updateSuccess,
    );
  }

  @override
  ScheduleFormUpdatePresenter presenterBuilder() => ScheduleFormUpdatePresenter();
}
