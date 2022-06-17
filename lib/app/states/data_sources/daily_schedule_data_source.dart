part of 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';

class DailyScheduleDataSource extends StateDataSource<DailySchedulePresenter> implements DailyScheduleContract {
  DailyScheduleListener get _listener => Get.find<DailyScheduleListener>(tag: ScheduleString.dailyScheduleTag);
  DailyScheduleProperty get _properties => Get.find<DailyScheduleProperty>(tag: ScheduleString.dailyScheduleTag);

  final _types = <String, int>{}.obs;
  Map<String, int> get types => _types.value;
  set types(Map<String, int> value) => _types.value = value;

  final _appointments = <Schedule>[].obs;
  List<Schedule> get appointments => _appointments.value;
  set appointments(List<Schedule> value) => _appointments.value = value;

  List<DBType> permissions = <DBType>[];

  void listToTypes(List types) {
    List<DBType> dbType = List<DBType>.from(types.map((e) => DBType.fromJson(e)).toList());
    this.types = dbType.asMap().map((i, e) => MapEntry(e.typename ?? "", e.typeid ?? 0));
  }

  void listToAppointments(List? value) {
    if (value != null) {
      appointments = List<Schedule>.from(value.map((item) => Schedule.fromJson(item)));
    }
  }

  void fetchData(String date) async {
    presenter.fetchData(date);
  }

  void deleteData(int scheduleid) => presenter.deleteData(scheduleid);

  @override
  DailySchedulePresenter presenterBuilder() => DailySchedulePresenter();

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['types'] != null) {
      listToTypes(data['types']);
    }
    if (data['schedules'] != null) {
      listToAppointments(data['schedules']);
    }
    if (data['permissions'] != null) {
      permissions = List<DBType>.from(data['permissions'].map((e) => DBType.fromJson(e)));
    }
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);

  @override
  void onDeleteError(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => _listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => _listener.onDeleteSuccess(message);
}
