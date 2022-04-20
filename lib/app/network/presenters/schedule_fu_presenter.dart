import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/services/schedule_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ScheduleFormUpdatePresenter {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();
  final _typeService = Get.find<TypeService>();

  late final UpdateContract _updateContract;
  set createContract(UpdateContract contract) => _updateContract = contract;

  late final FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;

  void updateSchedule(Map<String, dynamic> data) async {
    try {
      Response response = await _scheduleService.update(data['scheid'], data);
      if (response.statusCode == 200) {
        _updateContract.onUpdateSuccess(response.body['message']);
      } else {
        _updateContract.onUpdateFailed(response.body['message']);
      }
    } catch (err) {
      _updateContract.onUpdateFailed(err.toString());
    }
  }

  void fetchData(int scheduleId) async {
    try {
      Map data = {};
      Map<String, dynamic> params = {
        'typecd': DBTypeString.schedule,
      };
      Response typeResponse = await _typeService.byCode(params);
      Response scheduleResponse = await _scheduleService.show(scheduleId);

      if (typeResponse.statusCode == 200) {
        data['types'] = typeResponse.body;
        if (scheduleResponse.statusCode == 200) {
          data['schedule'] = scheduleResponse.body;
          _fetchDataContract.onLoadSuccess(data);
        } else {
          _fetchDataContract.onLoadFailed(scheduleResponse.body['message']);
        }
      } else {
        _fetchDataContract.onLoadFailed(typeResponse.body['message']);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  Future<List<UserDetail>> fetchUsers(String? search) async {
    UserDetail? activeUser = await findActiveUser();
    Map<String, dynamic> params = {
      'userdtbpid': activeUser?.userdtbpid.toString(),
      'search': search,
    };
    Response usersResponse = await _userService.select(params);
    if (usersResponse.statusCode == 200) {
      return List<UserDetail>.from(usersResponse.body.map((e) => UserDetail.fromJson(e)));
    }
    return [];
  }

  Future<UserDetail?> findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }
}
