import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ChatRoomPresenter extends RegularPresenter {
  final UserService _userService = Get.find<UserService>();

  Future<Response> _getUserDetail() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  SimpleFetcher<Map<String, dynamic>> get fetchUserDetail => SimpleFetcher(responseBuilder: _getUserDetail);
}
