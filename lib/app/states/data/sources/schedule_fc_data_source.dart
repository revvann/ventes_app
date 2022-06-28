import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/schedule_fc_presenter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/prospect_activity_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

class ScheduleFormCreateDataSource extends StateDataSource<ScheduleFormCreatePresenter> with DataSourceMixin {
  final String typesID = 'typshdr';
  final String createID = 'createhdr';
  final String refTypeID = 'reftypehdr';
  final String prospectID = 'refprospecthdr';
  final String createActivityRefID = 'createactrefhdr';

  late DataHandler<List<Map<String, int>>, List, Function()> typesHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> createHandler;
  late DataHandler<DBType?, Map<String, dynamic>, Function(int)> refTypeHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<ProspectActivity?, Map<String, dynamic>, Function(Map<String, dynamic>)> createActivityRefHandler;

  List<Map<String, int>> get types => typesHandler.value;
  DBType? get refType => refTypeHandler.value;
  ProspectActivity? get prospectActivity => createActivityRefHandler.value;

  String? typeName(int index) => types.isNotEmpty ? types[index].keys.first : null;
  List<String> typeNames() => types.map((type) => type.keys.first).toList();
  int? typeId(int index) => types.isNotEmpty ? types[index].values.first : null;

  List<Map<String, int>> insertTypes(List<Map<String, dynamic>> types) {
    List<DBType> typeMap = types.map((type) => DBType.fromJson(type)).toList();
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

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  void _createSuccess(String data) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: data,
        onFinished: (res) async {
          await property.scheduleNotification();
          Get.find<DailyScheduleStateController>().refreshStates();
          Get.back(id: ScheduleNavigator.id);
        },
      ),
    );
  }

  void _refTypeComplete() {
    if (refType?.typename == "Prospect Activity") {
      formSource.reference = ProspectActivity.fromJson(property.refData!);
      prospectHandler.fetcher.run(formSource.reference.prospectactivityprospectid);
    }
  }

  void _createActivityComplete() {
    if (prospectActivity != null) {
      formSource.scherefid = prospectActivity?.prospectactivityid;
      Map<String, dynamic> data = formSource.toJson();
      createHandler.fetcher.run(data);
    }
    Get.find<TaskHelper>().loaderPop(createActivityRefID);
  }

  @override
  void init() {
    super.init();
    typesHandler = DataHandler(
      typesID,
      fetcher: presenter.fetchTypes,
      initialValue: [],
      onError: (message) => _showError(typesID, message),
      onFailed: (message) => _showFailed(typesID, message),
      onSuccess: (data) => insertTypes(List<Map<String, dynamic>>.from(data)),
    );

    createHandler = DataHandler(
      createID,
      fetcher: presenter.create,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
      onError: (message) => _showError(createID, message),
      onFailed: (message) => _showFailed(createID, message),
      onSuccess: _createSuccess,
    );

    refTypeHandler = createDataHandler(refTypeID, presenter.fetchRefType, null, DBType.fromJson, onComplete: _refTypeComplete);
    prospectHandler = createDataHandler(prospectID, presenter.fetchRefFromProspect, null, Prospect.fromJson);
    createActivityRefHandler = DataHandler(
      createActivityRefID,
      fetcher: presenter.createRefFromActivity,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createActivityRefID)),
      onFailed: (message) => _showFailed(createActivityRefID, message, false),
      onSuccess: ProspectActivity.fromJson,
      onError: (message) => _showError(createActivityRefID, message),
      onComplete: _createActivityComplete,
    );
  }

  @override
  ScheduleFormCreatePresenter presenterBuilder() => ScheduleFormCreatePresenter();
}
