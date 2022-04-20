import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/network/presenters/daily_schedule_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';

class DailyScheduleDataSource {
  final DailySchedulePresenter _presenter = DailySchedulePresenter();
  set fetchContract(FetchDataContract contract) => _presenter.fetchContract = contract;

  final Rx<Map<String, int>> _types = Rx<Map<String, int>>({});
  Map<String, int> get types => _types.value;
  set types(Map<String, int> value) => _types.value = value;

  final Rx<List<Schedule>> _appointments = Rx<List<Schedule>>([]);
  List<Schedule> get appointments => _appointments.value;
  set appointments(List<Schedule> value) => _appointments.value = value;
  void listToAppointments(List? value) {
    if (value != null) {
      appointments = List<Schedule>.from(value.map((item) => Schedule.fromJson(item)));
    }
  }

  void fetchSchedules(String date) {
    _presenter.fetchSchedules(date);
  }

  void fetchTypes() async {
    types = await _presenter.fetchTypes();
  }
}
