import 'package:ventes/app/api/presenters/profile_presenter.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/profile_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';

class ProfileDataSource extends StateDataSource<ProfilePresenter> with DataSourceMixin {
  final String userDetailID = 'userdthdr';

  late DataHandler<UserDetail?, Map<String, dynamic>, Function()> userDetailHandler;

  UserDetail? get userDetail => userDetailHandler.value;

  @override
  init() {
    super.init();
    userDetailHandler = Utils.createDataHandler(userDetailID, presenter.fetchUserDetail, null, UserDetail.fromJson);
  }

  @override
  ProfilePresenter presenterBuilder() => ProfilePresenter();
}
