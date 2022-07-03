import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ChatRoomProperty extends StateProperty with PropertyMixin {
  int? userid;
  final Rx<List<Chat>> _chats = Rx<List<Chat>>([]);
  List<Chat> get chats => _chats.value;
  set chats(List<Chat> chats) => _chats.value = chats;

  Socket get socket => Get.find<Socket>();

  TextEditingController messageTEC = TextEditingController();

  @override
  void init() {
    super.init();
    socket.on('message', (data) {
      print(data);
    });
  }

  void ready() {
    super.ready();
    socket.emit('message', "testes");
  }

  @override
  void close() {
    super.close();
    messageTEC.dispose();
    socket.off('message');
  }
}

class Chat {
  String message;
  DateTime date;
  String deviceid;
  Chat(this.message, this.date, this.deviceid);
}
