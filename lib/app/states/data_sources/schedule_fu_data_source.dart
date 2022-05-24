import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/presenters/schedule_fu_presenter.dart';
import 'package:ventes/app/states/form_sources/schedule_fu_form_source.dart';
import 'package:ventes/app/states/listeners/schedule_fu_listener.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormUpdateDataSource implements FetchDataContract, UpdateContract {
  ScheduleFormUpdateListener get _listener => Get.find<ScheduleFormUpdateListener>();
  ScheduleFormUpdateFormSource get _formSource => Get.find<ScheduleFormUpdateFormSource>();

  final ScheduleFormUpdatePresenter _presenter = ScheduleFormUpdatePresenter();

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

  void init() {
    _presenter.fetchDataContract = this;
    _presenter.updateContract = this;
  }

  void insertTypes(List<Map<String, dynamic>> types) {
    List<DBType> typeMap = types.map((type) => DBType.fromJson(type)).where((element) => element.typeid == schedule?.schetypeid).toList();
    this.types = typeMap.map((type) => {type.typename ?? "": type.typeid ?? 0}).toList();
  }

  void fetchData() {
    _presenter.fetchData(scheduleId);
  }

  void updateSchedule(Map<String, dynamic> data) {
    _presenter.updateSchedule(data);
  }

  Future<UserDetail> get userActive async => (await _presenter.findActiveUser())!;

  Future<List<UserDetail>> filterUser(String? search) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    List<UserDetail> userDetails = await _presenter.fetchUsers(search);

    userDetails = userDetails.where((e) => e.userdtid != authModel?.accountActive).toList();
    return distinct(userDetails);
  }

  Future<List<UserDetail>> allUser(String? search) async {
    List<UserDetail> userDetails = await _presenter.fetchUsers(search);
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
    _formSource.prepareFormValue();
    Get.find<TaskHelper>().loaderPop(ScheduleString.updateScheduleTaskCode);
  }
}
