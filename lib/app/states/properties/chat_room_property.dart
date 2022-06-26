import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:ventes/helpers/task_helper.dart';

class ChatRoomProperty extends StateProperty with PropertyMixin {
  io.Socket? _socket;
  final Rx<List<Chat>> _chats = Rx<List<Chat>>([]);
  List<Chat> get chats => _chats.value;
  set chats(List<Chat> chats) => _chats.value = chats;

  TextEditingController messageTEC = TextEditingController();

  void connectSocket() {
    io.OptionBuilder optionsBuilder = io.OptionBuilder();
    optionsBuilder.setTransports(['websocket']);
    optionsBuilder.setAuth(dataSource.userDetail?.toJson() ?? {});
    Map<String, dynamic> options = optionsBuilder.build();

    _socket = io.io(RegularString.chatServer, options);
    _socket!.connect();
    _socket!.onConnect(listener.onSocketConnect);
    _socket!.onConnectError(listener.onSocketConnectError);
    _socket!.onDisconnect(listener.onSocketDisconnect);

    _socket!.on('message', (data) {
      List<Chat> chats = [];
      for (Map chatData in data) {
        Chat chat = Chat(chatData['message'], DateTime.fromMillisecondsSinceEpoch(chatData['date']), chatData['deviceid']);
        chats.add(chat);
      }
      this.chats = chats;
    });
  }

  void sendMessage() {
    if (_socket != null) {
      _socket!.emit('message', {
        'message': messageTEC.text,
        'deviceid': dataSource.userDetail?.user?.userdeviceid,
      });
      messageTEC.clear();
    } else {
      Get.find<TaskHelper>().failedPush(Task("socketerror", message: "You are not connected", snackbar: true));
    }
  }

  @override
  void close() {
    super.close();
    if (_socket != null) _socket!.dispose();
    messageTEC.dispose();
  }
}

class Chat {
  String message;
  DateTime date;
  String deviceid;
  Chat(this.message, this.date, this.deviceid);
}
