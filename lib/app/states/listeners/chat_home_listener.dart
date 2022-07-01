import 'package:get/get.dart';
import 'package:ventes/app/resources/views/chat_room/chat_room.dart';
import 'package:ventes/app/states/typedefs/chat_home_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ChatHomeListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.dashboard.index);
  }

  void navigateToRoom() {
    Get.toNamed(ChatRoomView.route, id: Views.dashboard.index);
  }

  @override
  Future onReady() async {
    dataSource.usersHandler.fetcher.run();
  }
}
