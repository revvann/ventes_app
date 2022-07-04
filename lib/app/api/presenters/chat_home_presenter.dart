import 'package:get/get.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ChatHomePresenter extends RegularPresenter {
  final UserService _userService = Get.find<UserService>();

  Future<Response> _getUsers() async {
    int? bpid = (await _findActiveUser())?.userdtbpid;
    return _userService.select({
      'userdtbpid': bpid?.toString(),
    });
  }

  Future<UserDetail?> _findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  SimpleFetcher<List> get fetchUsers => SimpleFetcher(responseBuilder: _getUsers, failedMessage: DashboardString.fetchFailed);
}
