import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/ProfilePresenter.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/profile_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';

class ProfileDataSource extends StateDataSource<ProfilePresenter> with DataSourceMixin implements FetchDataContract {
  final Rx<UserDetail?> _userDetail = Rx<UserDetail?>(null);
  UserDetail? get userDetail => _userDetail.value;
  set userDetail(UserDetail? value) => _userDetail.value = value;

  void fetchData() => presenter.fetchData();

  @override
  onLoadComplete() => listener.onLoadComplete();

  @override
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data.containsKey('userdetail')) {
      userDetail = UserDetail.fromJson(data['userdetail']);
    }
  }

  @override
  ProfilePresenter presenterBuilder() => ProfilePresenter();
}
