import 'package:ventes/contracts/create_contract.dart';
import 'package:ventes/contracts/fetch_data_contract.dart';
import 'package:ventes/models/user_detail_model.dart';
import 'package:ventes/presenters/schedule_fc_presenter.dart';

class ScheduleFormCreateDataSource {
  final ScheduleFormCreatePresenter _presenter = ScheduleFormCreatePresenter();
  set fetchDataContract(FetchDataContract value) => _presenter.fetchDataContract = value;
  set createContract(CreateContract value) => _presenter.createContract = value;

  void fetchUser() => _presenter.fetchUser();

  void createSchedule(Map<String, dynamic> data) {
    _presenter.createSchedule(data);
  }

  Future<List<UserDetail>> filterUser(String? search) async {
    return _presenter.filterUser(search);
  }
}
