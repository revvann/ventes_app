import 'package:get/get.dart';
import 'package:ventes/contracts/fetch_data_contract.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/models/auth_model.dart';
import 'package:ventes/models/user_model.dart';
import 'package:ventes/services/user_service.dart';

class ScheduleFormCreatePresenter {
  final _userService = Get.find<UserService>();

  late final FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;

  void fetchUser() async {
    try {
      AuthModel? authModel = await Get.find<AuthHelper>().get();
      Response response = await _userService.show(authModel!.accountActive!);

      Map<String, dynamic> params = {
        'userdtbpid': response.body['userdtbpid'].toString(),
      };
      Response usersResponse = await _userService.select(params);
      List<User> users = List<User>.from(usersResponse.body.map((e) => User.fromJson(e)));
      _fetchDataContract.onLoadSuccess({
        'users': users,
      });
    } catch (err) {
      print(err.toString());
      _fetchDataContract.onLoadFailed(err.toString());
    }
  }
}
