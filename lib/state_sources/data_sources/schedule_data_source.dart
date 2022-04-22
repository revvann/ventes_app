// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/network/presenters/schedule_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';

class ScheduleDataSource {
  final SchedulePresenter _presenter = SchedulePresenter();
  set fetchContract(FetchDataContract value) => _presenter.fetchContract = value;

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

  void fetchSchedules([int? month]) {
    _presenter.fetchSchedules(month);
  }

  void fetchTypes() async {
    types = await _presenter.fetchTypes();
  }
}