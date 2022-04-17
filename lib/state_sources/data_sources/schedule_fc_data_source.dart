import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/network/contracts/create_contract.dart';
import 'package:ventes/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/presenters/schedule_fc_presenter.dart';

class ScheduleFormCreateDataSource {
  final ScheduleFormCreatePresenter _presenter = ScheduleFormCreatePresenter();
  set fetchDataContract(FetchDataContract value) =>
      _presenter.fetchDataContract = value;
  set createContract(CreateContract value) => _presenter.createContract = value;

  void createSchedule(Map<String, dynamic> data) {
    _presenter.createSchedule(data);
  }

  Future<UserDetail> get userActive async =>
      (await _presenter.findActiveUser())!;

  Future<List<UserDetail>> filterUser(String? search) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    List<UserDetail> userDetails = await _presenter.getUsers(search);

    userDetails = userDetails
        .where((e) => e.userdtid != authModel?.accountActive)
        .toList();
    return distinct(userDetails);
  }

  Future<List<UserDetail>> allUser(String? search) async {
    List<UserDetail> userDetails = await _presenter.getUsers(search);
    return distinct(userDetails);
  }

  List<UserDetail> distinct(List<UserDetail> userDetails) {
    Map<int, int> userIds = userDetails
        .asMap()
        .map((k, v) => MapEntry(v.userid ?? 0, v.userdtid ?? 0));
    userDetails = userDetails.where((e) {
      bool isExist = userIds.containsKey(e.userid);
      int userdtid = userIds[e.userid] ?? 0;
      return isExist && e.userdtid == userdtid;
    }).toList();
    return userDetails;
  }
}
