import 'package:get/get.dart';
import 'package:ventes/network/contracts/create_contract.dart';
import 'package:ventes/network/contracts/fetch_data_contract.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/network/services/schedule_service.dart';
import 'package:ventes/network/services/user_service.dart';

class ScheduleFormCreatePresenter {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();

  late final FetchDataContract _fetchDataContract;
  late final CreateContract _createContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;
  set createContract(CreateContract contract) => _createContract = contract;

  void fetchUser() async {
    try {
      AuthModel? authModel = await Get.find<AuthHelper>().get();
      Response response = await _userService.show(authModel!.accountActive!);

      Map<String, dynamic> params = {
        'userdtbpid': response.body['userdtbpid'].toString(),
      };
      Response usersResponse = await _userService.select(params);
      if (usersResponse.statusCode == 200) {
        List<UserDetail> users = List<UserDetail>.from(usersResponse.body.map((e) => UserDetail.fromJson(e)));
        _fetchDataContract.onLoadSuccess({
          'users': users,
        });
      } else {
        _fetchDataContract.onLoadFailed(usersResponse.body['message']);
      }
    } catch (err) {
      _fetchDataContract.onLoadFailed(err.toString());
    }
  }

  void createSchedule(Map<String, dynamic> data) async {
    try {
      Response response = await _scheduleService.store(data);
      if (response.statusCode == 200) {
        _createContract.onCreateSuccess(response.body['message']);
      } else {
        _createContract.onCreateFailed(response.body['message']);
      }
    } catch (err) {
      _createContract.onCreateFailed(err.toString());
    }
  }

  Future<List<UserDetail>> filterUser(String? search) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    Map<String, dynamic> params = {
      'userdtbpid': response.body['userdtbpid'].toString(),
      'search': search,
    };
    Response usersResponse = await _userService.select(params);
    if (usersResponse.statusCode == 200) {
      List<UserDetail> userDetails = List<UserDetail>.from(usersResponse.body.map((e) => UserDetail.fromJson(e)));
      userDetails = userDetails.where((e) => e.userdtid != authModel.accountActive).toList();
      Map<int, int> userIds = userDetails.asMap().map((k, v) => MapEntry(v.userid ?? 0, v.userdtid ?? 0));
      userDetails = userDetails.where((e) {
        bool isExist = userIds.containsKey(e.userid);
        int userdtid = userIds[e.userid] ?? 0;
        return isExist && e.userdtid == userdtid;
      }).toList();

      return userDetails;
    }
    return [];
  }
}
