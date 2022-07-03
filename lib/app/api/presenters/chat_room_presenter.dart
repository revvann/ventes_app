import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ChatRoomPresenter extends RegularPresenter {
  final UserService _userService = Get.find<UserService>();

  Future<Response> _getUserDetail(int id) async {
    return await _userService.show(id);
  }

  DataFetcher<Function(int), Map<String, dynamic>> get fetchUserDetail => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getUserDetail(id);
            if (response.statusCode == 200) {
              handler.success(response.body);
            } else {
              handler.failed(DashboardString.fetchFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
