import 'package:get/get.dart';
import 'package:ventes/app/api/models/chat_model.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class ChatRoomListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.dashboard.index);
  }

  void sendMessage() {
    Chat chat = Chat(
      chatbpid: dataSource.userDetail?.userdtbpid,
      chatmessage: property.messageTEC.text,
      chatreceiverid: dataSource.receiverDetail?.userid,
      createdby: dataSource.userDetail?.userid,
    );
    property.sendMessage({
      "to": dataSource.receiverDetail?.user?.usersocketid,
      "chat": chat.toJson(),
    });
    property.messageTEC.clear();
  }

  void onMessage(chats) {
    property.chats = chats.map<Chat>((item) => Chat.fromJson(item)).toList();
  }

  void onMessageFailed(message) {
    Get.find<TaskHelper>().failedPush(Task('messagefailed', message: message, snackbar: true));
  }

  void onMessageError(message) {
    Get.find<TaskHelper>().errorPush(Task('messageerror', message: message));
  }

  @override
  Future onReady() async {
    dataSource.receiverDetailHandler.fetcher.run(property.userid!);
    dataSource.userDetailHandler.fetcher.run();
  }
}
