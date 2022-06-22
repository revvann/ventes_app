import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/schedule_fc_presenter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormCreateDataSource extends StateDataSource<ScheduleFormCreatePresenter> with DataSourceMixin implements ScheduleCreateContract {
  final Rx<List<Map<String, int>>?> _types = Rx<List<Map<String, int>>?>(null);
  List<Map<String, int>>? get types => _types.value;
  set types(List<Map<String, int>>? value) => _types.value = value;

  String typeName(int index) => types?[index].keys.first ?? "";
  List<String> typeNames() => types?.map((type) => type.keys.first).toList() ?? <String>[];
  int typeId(int index) => types?[index].values.first ?? 0;

  void insertTypes(List<Map<String, dynamic>> types) {
    List<DBType> typeMap = types.map((type) => DBType.fromJson(type)).toList();
    this.types = typeMap.map((type) => {type.typename ?? "": type.typeid ?? 0}).toList();
  }

  void fetchTypes() {
    presenter.fetchTypes();
  }

  void createSchedule(Map<String, dynamic> data) {
    presenter.createSchedule(data);
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
  ScheduleFormCreatePresenter presenterBuilder() => ScheduleFormCreatePresenter();

  @override
  void onCreateFailed(String message) => listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => listener.onCreateDataSuccess(message);

  @override
  void onCreateError(String message) => listener.onCreateDataError(message);

  @override
  onLoadError(String message) => listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    insertTypes(List<Map<String, dynamic>>.from(data['types']));
  }

  @override
  void onCreateComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
