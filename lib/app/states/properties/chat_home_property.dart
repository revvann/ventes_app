import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:ventes/app/states/typedefs/chat_home_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ChatHomeProperty extends StateProperty with PropertyMixin {
  Socket get socket => Get.find<Socket>();

  @override
  void ready() {
    super.ready();
    socket.on('usersonline', (data) {
      dataSource.usersActive = data;
    });
  }
}
