import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/presenters/daily_schedule_presenter.dart';
import 'package:ventes/network/contracts/fetch_data_contract.dart';

class DailyScheduleDataSource {
  final DailySchedulePresenter _presenter = DailySchedulePresenter();
  set fetchContract(FetchDataContract contract) => _presenter.fetchContract = contract;

  final Rx<List<Schedule>> _appointments = Rx<List<Schedule>>([]);
  List<Schedule> get appointments => _appointments.value;
  set appointments(List<Schedule> value) => _appointments.value = value;

  void fetchSchedules(String date) {
    _presenter.fetchSchedules(date);
  }
}
