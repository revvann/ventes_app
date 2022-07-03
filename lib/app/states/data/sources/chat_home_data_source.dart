import 'package:ventes/app/api/presenters/chat_home_presenter.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/chat_home_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';

class ChatHomeDataSource extends StateDataSource<ChatHomePresenter> with DataSourceMixin {
  final String usersID = 'users';

  late DataHandler<List<UserDetail>, List, Function()> usersHandler;

  @override
  void init() {
    super.init();
    usersHandler = Utils.createDataHandler(usersID, presenter.fetchUsers, [], (data) => data.map((e) => UserDetail.fromJson(e)).toList());
  }

  @override
  ChatHomePresenter presenterBuilder() => ChatHomePresenter();
}
