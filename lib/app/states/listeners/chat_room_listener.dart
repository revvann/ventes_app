import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ChatRoomListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.dashboard.index);
  }

  void sendMessage() {
    property.socket.emit('message', "this is message from me");
  }

  @override
  Future onReady() async {
    dataSource.userDetailHandler.fetcher.run(property.userid!);
  }
}
