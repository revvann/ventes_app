import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ChatRoomListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.dashboard.index);
  }

  void onSocketConnect(data) {
    printSocket("Connected");
  }

  void onSocketConnectError(data) {
    printSocket("An error was accured");
    print(data);
  }

  void onSocketDisconnect(data) {
    printSocket("You're disconnected");
  }

  void printSocket(dynamic data) {
    print("socket: $data");
  }

  @override
  Future onReady() async {
    dataSource.userDetailHandler.fetcher.run();
  }
}
