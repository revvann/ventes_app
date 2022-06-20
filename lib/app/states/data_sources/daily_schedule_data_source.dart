import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/daily_schedule_presenter.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/states/typedefs/daily_schedule_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class DailyScheduleDataSource extends StateDataSource<DailySchedulePresenter> with DataSourceMixin implements DailyScheduleContract {
  final _types = Rx<Map<String, int>>({});
  Map<String, int> get types => _types.value;
  set types(Map<String, int> value) => _types.value = value;

  final _appointments = Rx<List<Schedule>>([]);
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
  onLoadFailed(String message) => listener.onLoadDataFailed(message);

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
    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  onLoadError(String message) => listener.onLoadDataError(message);

  @override
  void onDeleteError(String message) => listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => listener.onDeleteSuccess(message);

  @override
  void onDeleteComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
