import 'package:file_picker/file_picker.dart';
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

  final Rx<FilePickerResult?> _chatFiles = Rx(null);
  FilePickerResult? get chatFiles => _chatFiles.value;
  set chatFiles(FilePickerResult? file) => _chatFiles.value = file;

  Socket get socket => Get.find<Socket>();

  TextEditingController messageTEC = TextEditingController();

  void sendMessage(Map<String, dynamic> data, {bool binary = false}) {
    if (binary) {
      socket.emitWithAck('message', data, binary: true);
    } else {
      socket.emit('message', data);
    }
  }

  String sizeShort(int price) {
    if (price < 1e3) {
      return "${price.toStringAsFixed(0)} B";
    } else if (price < 1e6) {
      return "${(price ~/ 1e3)} KB";
    } else if (price < 1e9) {
      return "${(price ~/ 1e6)} MB";
    } else {
      return "${(price ~/ 1e9)} GB";
    }
  }

  @override
  void ready() {
    super.ready();
    socket.on('message', listener.onMessage);
    socket.on('messagefailed', listener.onFailed);
    socket.on('messageerror', listener.onError);
    socket.on('readmessagefailed', listener.onFailed);
    socket.on('readmessageerror', listener.onError);
    socket.emit('usersonline', {'userId': 12});
  }

  @override
  void close() {
    super.close();
    messageTEC.dispose();
    socket.off('message');
  }
}
