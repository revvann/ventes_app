import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/request_code.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/services/schedule_service.dart';
import 'package:ventes/app/network/services/user_service.dart';

class ScheduleFormCreatePresenter {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();
  final _typeService = Get.find<TypeService>();

  late final CreateContract _createContract;
  set createContract(CreateContract contract) => _createContract = contract;

  late final FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;

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

  void fetchTypes() async {
    try {
      Map<String, dynamic> params = {
        'typecd': DBTypeString.schedule,
      };
      Response response = await _typeService.byCode(params);
      if (response.statusCode == 200) {
        _fetchDataContract.onLoadSuccess({'types': response.body});
      } else {
        _fetchDataContract.onLoadFailed(response.body['message']);
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
