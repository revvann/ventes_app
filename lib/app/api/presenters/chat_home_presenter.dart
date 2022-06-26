import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ChatHomePresenter extends RegularPresenter {
  final UserService _userService = Get.find<UserService>();

  Future<Response> _getUsers() {
    return _userService.select();
  }

  SimpleFetcher<List> get fetchUsers => SimpleFetcher(responseBuilder: _getUsers, failedMessage: DashboardString.fetchFailed);
}
