import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/services/schedule_service.dart';
import 'package:ventes/app/network/services/user_service.dart';

class ScheduleFormCreatePresenter extends RegularPresenter<ScheduleCreateContract> {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();
  final _typeService = Get.find<TypeService>();

  void createSchedule(Map<String, dynamic> data) async {
    try {
      Response response = await _scheduleService.store(data);
      if (response.statusCode == 200) {
        contract.onCreateSuccess(response.body['message']);
      } else {
        contract.onCreateFailed(response.body['message']);
      }
    } catch (err) {
      contract.onCreateFailed(err.toString());
    }
  }

  void fetchTypes() async {
    try {
      Map<String, dynamic> params = {
        'typecd': DBTypeString.schedule,
      };
      Response response = await _typeService.byCode(params);
      if (response.statusCode == 200) {
        contract.onLoadSuccess({'types': response.body});
      } else {
        contract.onLoadFailed(response.body['message']);
      }
    } catch (err) {
      contract.onLoadError(err.toString());
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

abstract class ScheduleCreateContract implements FetchDataContract, CreateContract {}
