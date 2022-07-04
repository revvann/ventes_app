import 'package:ventes/app/api/models/chat_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/chat_room_presenter.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';

class ChatRoomDataSource extends StateDataSource<ChatRoomPresenter> with DataSourceMixin {
  final String receiverDetailID = 'receiverid';
  final String userDetailID = 'userdtid';
  final String chatsID = 'chatsid';

  late DataHandler<UserDetail?, Map<String, dynamic>, Function(int)> receiverDetailHandler;
  late DataHandler<UserDetail?, Map<String, dynamic>, Function()> userDetailHandler;
  late DataHandler<List<Chat>, List, Function(int)> chatsHandler;

  UserDetail? get receiverDetail => receiverDetailHandler.value;
  UserDetail? get userDetail => userDetailHandler.value;

  @override
  void init() {
    super.init();
    receiverDetailHandler = Utils.createDataHandler(
      receiverDetailID,
      presenter.fetchReceiverDetail,
      null,
      UserDetail.fromJson,
      onComplete: () {
        if (receiverDetail != null) {
          chatsHandler.fetcher.run(receiverDetail!.userid!);
        }
      },
    );
    userDetailHandler = Utils.createDataHandler(
      userDetailID,
      presenter.fetchUserDetail,
      null,
      UserDetail.fromJson,
    );
    chatsHandler = Utils.createDataHandler(
      chatsID,
      presenter.fetchChats,
      [],
      (data) => data.map<Chat>((e) => Chat.fromJson(e)).toList(),
      onComplete: () {
        property.chats = chatsHandler.value;
      },
    );
  }

  @override
  ChatRoomPresenter presenterBuilder() => ChatRoomPresenter();
}
