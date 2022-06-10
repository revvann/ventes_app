// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/states/controllers/schedule_state_controller.dart';

class _DataSource extends RegularDataSource<SchedulePresenter> implements FetchDataContract {
  _Listener get _listener => Get.find<_Listener>(tag: ScheduleString.scheduleTag);

  final _types = <String, int>{}.obs;
  Map<String, int> get types => _types.value;
  set types(Map<String, int> value) => _types.value = value;

  final _appointments = <Schedule>[].obs;
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
