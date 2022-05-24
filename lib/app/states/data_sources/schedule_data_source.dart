// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/schedule_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/states/listeners/schedule_listener.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleDataSource implements FetchDataContract {
  ScheduleListener get _listener => Get.find<ScheduleListener>();
  final SchedulePresenter _presenter = SchedulePresenter();

  final _types = <String, int>{}.obs;
  Map<String, int> get types => _types.value;
  set types(Map<String, int> value) => _types.value = value;

  final _appointments = <Schedule>[].obs;
  List<Schedule> get appointments => _appointments.value;
  set appointments(List<Schedule> value) => _appointments.value = value;

  void init() {
    _presenter.fetchContract = this;
  }

  void listToTypes(List types) {
    List<DBType> dbType = List<DBType>.from(types.map((e) => DBType.fromJson(e)).toList());
    this.types = dbType.asMap().map((i, e) => MapEntry(e.typename ?? "", e.typeid ?? 0));
  }

  void listToAppointments(List? value) {
    if (value != null) {
      appointments = List<Schedule>.from(value.map((item) => Schedule.fromJson(item)));
    }
  }

  void fetchSchedules([int? month]) {
    _presenter.fetchSchedules(month);
  }

  void fetchData([int? scheduleMonth]) {
    _presenter.fetchData(scheduleMonth);
  }

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['schedules'] != null) {
      print(data['schedules']);
      listToAppointments(data['schedules']);
    }
    if (data['types'] != null) {
      listToTypes(data['types']);
    }
    Get.find<TaskHelper>().loaderPop(ScheduleString.taskCode);
  }

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);
}
