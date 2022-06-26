import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/chat_room_presenter.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ChatRoomDataSource extends StateDataSource<ChatRoomPresenter> with DataSourceMixin {
  final String userDetailID = 'userdtid';

  late DataHandler<UserDetail?, Map<String, dynamic>, Function()> userDetailHandler;

  UserDetail? get userDetail => userDetailHandler.value;

  UserDetail _userDetailSuccess(data) {
    Get.find<TaskHelper>().successPush(Task(userDetailID, message: "you are connected", onFinished: (res) => property.connectSocket()));
    return UserDetail.fromJson(data);
  }

  @override
  void init() {
    super.init();
    userDetailHandler = createDataHandler(
      userDetailID,
      presenter.fetchUserDetail,
      null,
      _userDetailSuccess,
    );
  }

  @override
  ChatRoomPresenter presenterBuilder() => ChatRoomPresenter();
}
