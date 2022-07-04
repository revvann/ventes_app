import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/chat_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ChatRoomPresenter extends RegularPresenter {
  final UserService _userService = Get.find<UserService>();
  final ChatService _chatService = Get.find<ChatService>();

  Future<Response> _getReceiverDetail(int id) async {
    return await _userService.show(id);
  }

  Future<Response> _getUserDetail() async {
    int? id = Get.find<AuthHelper>().userId.val;
    return await _userService.show(id!);
  }

  Future<Response> _getChats(int receiverid) async {
    int? id = Get.find<AuthHelper>().userId.val;
    return await _chatService.select({
      'user1': id?.toString(),
      'user2': receiverid.toString(),
    });
  }

  DataFetcher<Function(int), Map<String, dynamic>> get fetchReceiverDetail => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getReceiverDetail(id);
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

  DataFetcher<Function(int), List> get fetchChats => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getChats(id);
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

  SimpleFetcher<Map<String, dynamic>> get fetchUserDetail => SimpleFetcher(responseBuilder: _getUserDetail, failedMessage: DashboardString.fetchFailed);
}
