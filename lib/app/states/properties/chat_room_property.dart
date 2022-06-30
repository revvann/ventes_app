import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ChatRoomProperty extends StateProperty with PropertyMixin {
  final Rx<List<Chat>> _chats = Rx<List<Chat>>([]);
  List<Chat> get chats => _chats.value;
  set chats(List<Chat> chats) => _chats.value = chats;

  TextEditingController messageTEC = TextEditingController();

  @override
  void close() {
    super.close();
    messageTEC.dispose();
  }
}

class Chat {
  String message;
  DateTime date;
  String deviceid;
  Chat(this.message, this.date, this.deviceid);
}
