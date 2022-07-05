import 'package:get/get.dart';
import 'package:ventes/core/api/service.dart';

class ChatService extends Service {
  @override
  String get api => "/chat";

  Future<Response> getConversation(int user1, int user2) async {
    return await get(
      '$api/conversation',
      query: {
        'user1': user1.toString(),
        'user2': user2.toString(),
      },
    );
  }

  Future<Response> readMessages(int userid) async {
    return await get(
      '$api/read',
      query: {
        'userid': userid.toString(),
      },
    );
  }
}
