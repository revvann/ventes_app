import 'package:get/get.dart';
import 'package:ventes/network/contracts/create_contract.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/network/services/schedule_service.dart';
import 'package:ventes/network/services/user_service.dart';

class ScheduleFormCreatePresenter {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();

  late final CreateContract _createContract;
  set createContract(CreateContract contract) => _createContract = contract;

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

  Future<List<UserDetail>> getUsers(String? search) async {
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
