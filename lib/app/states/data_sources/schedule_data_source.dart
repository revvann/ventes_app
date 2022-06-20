// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/schedule_presenter.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/states/typedefs/schedule_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleDataSource extends StateDataSource<SchedulePresenter> with DataSourceMixin implements FetchDataContract {
  final _types = Rx<Map<String, int>>({});
  Map<String, int> get types => _types.value;
  set types(Map<String, int> value) => _types.value = value;

  final _permissions = Rx<List<DBType>>([]);
  List<DBType> get permissions => _permissions.value;
  set permissions(List<DBType> value) => _permissions.value = value;

  final _appointments = Rx<List<Schedule>>([]);
  List<Schedule> get appointments => _appointments.value;
  set appointments(List<Schedule> value) => _appointments.value = value;

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
    presenter.fetchSchedules(month);
  }

  void fetchData([int? scheduleMonth]) {
    presenter.fetchData(scheduleMonth);
  }

  @override
  SchedulePresenter presenterBuilder() => SchedulePresenter();

  @override
  onLoadFailed(String message) => listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['schedules'] != null) {
      listToAppointments(data['schedules']);
    }
    if (data['types'] != null) {
      listToTypes(data['types']);
    }
    if (data['permissions'] != null) {
      permissions = List<DBType>.from(data['permissions'].map((e) => DBType.fromJson(e)));
    }
    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  onLoadError(String message) => listener.onLoadDataError(message);

  @override
  onLoadComplete() => listener.onComplete();
}
