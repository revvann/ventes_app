import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/app/api/presenters/schedule_fc_presenter.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/prospect_activity_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormCreateDataSource extends StateDataSource<ScheduleFormCreatePresenter> with DataSourceMixin {
  final String typesID = 'typshdr';
  final String createID = 'createhdr';
  final String refTypeID = 'reftypehdr';
  final String prospectID = 'refprospecthdr';
  final String createActivityRefID = 'createactrefhdr';
  final String sendMessageID = 'sendmessagehdr';
  final String userID = 'userhdr';

  late DataHandler<List<Map<String, int>>, List, Function()> typesHandler;
  late DataHandler<Schedule?, Map<String, dynamic>, Function(Map<String, dynamic>)> createHandler;
  late DataHandler<DBType?, Map<String, dynamic>, Function(int)> refTypeHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<ProspectActivity?, Map<String, dynamic>, Function(Map<String, dynamic>)> createActivityRefHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> sendMessageHandler;
  late DataHandler<UserDetail?, Map<String, dynamic>, Function()> userHandler;

  List<Map<String, int>> get types => typesHandler.value;
  DBType? get refType => refTypeHandler.value;
  ProspectActivity? get prospectActivity => createActivityRefHandler.value;
  Prospect? get prospect => prospectHandler.value;
  UserDetail? get userDetail => userHandler.value;
  Schedule? get schedule => createHandler.value;

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

  void _sendMessageSuccess(String data) {
    Get.find<TaskHelper>().successPush(
      Task(
        sendMessageID,
        message: data,
        onFinished: (res) async {
          Get.back(id: Views.schedule.index);
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
      Get.find<TaskHelper>().successPush(Task(createActivityRefID, message: "Reference created successfully", snackbar: true));
      formSource.scherefid = prospectActivity?.prospectactivityid;
      Map<String, dynamic> data = formSource.toJson();
      createHandler.fetcher.run(data);
    }
    Get.find<TaskHelper>().loaderPop(createActivityRefID);
  }

  void _createComplete() {
    property.scheduleNotification();
    Get.find<TaskHelper>().loaderPop(createID);
  }

  @override
  void init() {
    super.init();
    typesHandler = DataHandler(
      typesID,
      fetcher: presenter.fetchTypes,
      initialValue: [],
      onError: (message) => Utils.showError(typesID, message),
      onFailed: (message) => Utils.showFailed(typesID, message),
      onSuccess: (data) => insertTypes(List<Map<String, dynamic>>.from(data)),
    );

    userHandler = DataHandler(
      userID,
      fetcher: presenter.fetchUserDetail,
      initialValue: null,
      onError: (message) => Utils.showError(userID, message),
      onFailed: (message) => Utils.showFailed(userID, message),
      onSuccess: UserDetail.fromJson,
    );

    createHandler = DataHandler(
      createID,
      fetcher: presenter.create,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onComplete: _createComplete,
      onError: (message) => Utils.showError(createID, message),
      onFailed: (message) => Utils.showFailed(createID, message),
      onSuccess: Schedule.fromJson,
    );

    sendMessageHandler = DataHandler(
      sendMessageID,
      fetcher: presenter.sendMessage,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(sendMessageID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(sendMessageID),
      onError: (message) => Utils.showError(sendMessageID, message),
      onFailed: (message) => Utils.showFailed(sendMessageID, message),
      onSuccess: _sendMessageSuccess,
    );

    refTypeHandler = Utils.createDataHandler(refTypeID, presenter.fetchRefType, null, DBType.fromJson, onComplete: _refTypeComplete);
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchRefFromProspect, null, Prospect.fromJson);
    createActivityRefHandler = DataHandler(
      createActivityRefID,
      fetcher: presenter.createRefFromActivity,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createActivityRefID)),
      onFailed: (message) => Utils.showFailed(createActivityRefID, message, false),
      onSuccess: ProspectActivity.fromJson,
      onError: (message) => Utils.showError(createActivityRefID, message),
      onComplete: _createActivityComplete,
    );
  }

  @override
  ScheduleFormCreatePresenter presenterBuilder() => ScheduleFormCreatePresenter();
}
