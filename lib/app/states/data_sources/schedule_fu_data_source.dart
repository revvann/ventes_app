import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/schedule_fu_presenter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_fu_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormUpdateDataSource extends StateDataSource<ScheduleFormUpdatePresenter> implements ScheduleUpdateContract {
  Listener get _listener => Get.find<Listener>(tag: ScheduleString.scheduleUpdateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: ScheduleString.scheduleUpdateTag);
  Property get _property => Get.find<Property>(tag: ScheduleString.scheduleUpdateTag);

  late int scheduleId;

  final Rx<List<Map<String, int>>?> _types = Rx<List<Map<String, int>>?>(null);
  List<Map<String, int>>? get types => _types.value;
  set types(List<Map<String, int>>? value) => _types.value = value;

  String typeName(int index) => types?[index].keys.first ?? "";
  List<String> typeNames() => types?.map((type) => type.keys.first).toList() ?? <String>[];
  int typeId(int index) => types?[index].values.first ?? 0;
  List<int> typeIds() => types?.map((type) => type.values.first).toList() ?? <int>[];
  int typeIndex(int id) => typeIds().isNotEmpty ? typeIds().indexOf(id) : -1;

  final Rx<Schedule?> _schedule = Rx<Schedule?>(null);
  Schedule? get schedule => _schedule.value;
  set schedule(Schedule? value) => _schedule.value = value;

  void insertTypes(List<Map<String, dynamic>> types) {
    List<DBType> typeMap = types.map((type) => DBType.fromJson(type)).where((element) => element.typeid == schedule?.schetypeid).toList();
    this.types = typeMap.map((type) => {type.typename ?? "": type.typeid ?? 0}).toList();
  }

  void fetchData() {
    presenter.fetchData(scheduleId);
  }

  void updateSchedule(Map<String, dynamic> data) {
    presenter.updateSchedule(data);
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

  @override
  ScheduleFormUpdatePresenter presenterBuilder() => ScheduleFormUpdatePresenter();

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    schedule = Schedule.fromJson(data['schedule']);
    insertTypes(List<Map<String, dynamic>>.from(data['types']));
    _formSource.prepareFormValues();
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }
}
