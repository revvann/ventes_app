import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/constants/strings/profile_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProfilePresenter extends RegularPresenter<FetchDataContract> {
  final UserService _userService = Get.find<UserService>();

  Future<Response> _getUserDetail() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  void fetchData() async {
    Map<String, dynamic> data = {};
    try {
      Response response = await _getUserDetail();
      if (response.statusCode == 200) {
        data['userdetail'] = response.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProfileString.fetchFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }
}
