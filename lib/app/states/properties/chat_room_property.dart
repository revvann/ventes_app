import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:ventes/app/api/models/chat_model.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ChatRoomProperty extends StateProperty with PropertyMixin {
  int? userid;
  final Rx<List<Chat>> _chats = Rx<List<Chat>>([]);
  List<Chat> get chats => _chats.value;
  set chats(List<Chat> chats) => _chats.value = chats;

  Socket get socket => Get.find<Socket>();

  TextEditingController messageTEC = TextEditingController();

  void sendMessage(Map<String, dynamic> data) {
    socket.emit('message', data);
  }

  @override
  void ready() {
    super.ready();
    socket.on('message', listener.onMessage);
    socket.on('messagefailed', listener.onFailed);
    socket.on('messageerror', listener.onError);
    socket.on('readmessagefailed', listener.onFailed);
    socket.on('readmessageerror', listener.onError);
  }

  @override
  void close() {
    super.close();
    messageTEC.dispose();
    socket.off('message');
  }
}
