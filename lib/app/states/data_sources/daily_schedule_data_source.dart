import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/daily_schedule_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/states/listeners/daily_schedule_listener.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class DailyScheduleDataSource implements FetchDataContract {
  DailyScheduleListener get _listener => Get.find<DailyScheduleListener>();

  final DailySchedulePresenter _presenter = DailySchedulePresenter();

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

  void fetchData(String date) async {
    _presenter.fetchData(date);
  }

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
    Get.find<TaskHelper>().loaderPop(ScheduleString.dailyScheduleTaskCode);
  }

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);
}
