import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/models/user_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/logout_contract.dart';
import 'package:ventes/app/network/presenters/dashboard_presenter.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/states/listeners/dashboard_listener.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardDataSource implements FetchDataContract, LogoutContract {
  DashboardProperties get _properties => Get.find<DashboardProperties>();
  DashboardListener get _listener => Get.find<DashboardListener>();

  final DashboardPresenter _presenter = DashboardPresenter();

  final _customers = <BpCustomer>[].obs;
  set customers(List<BpCustomer> value) => _customers.value = value;
  List<BpCustomer> get customers => _customers.value;

  final _accounts = Rx<List<UserDetail>>([]);
  set accounts(List<UserDetail> value) => _accounts.value = value;
  List<UserDetail> get accounts => _accounts.value;

  final _account = Rx<UserDetail?>(null);
  set account(UserDetail? value) => _account.value = value;
  UserDetail? get account => _account.value;

  final _scheduleCount = 0.obs;
  set scheduleCount(int value) => _scheduleCount.value = value;
  int get scheduleCount => _scheduleCount.value;

  final _activeUser = Rx<UserDetail?>(null);
  UserDetail? get activeUser => _activeUser.value;
  set activeUser(UserDetail? value) => _activeUser.value = value;

  final _currentPosition = Rx<MapsLoc?>(null);
  MapsLoc? get currentPosition => _currentPosition.value;
  set currentPosition(MapsLoc? value) => _currentPosition.value = value;

  void init() {
    _presenter.fetchDataContract = this;
    _presenter.logoutContract = this;
  }

  void fetchData(LatLng position) => _presenter.fetchData(position.latitude, position.longitude);
  void logout() => _presenter.logout();

  void customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers
        .map((element) {
          LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
          double radius = calculateDistance(coords1, coords2);
          element.radius = radius;
          return element;
        })
        .where((element) => element.radius != null ? element.radius! <= 100 : false)
        .toList();
  }

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) async {
    if (data['customers'] != null) {
      customersFromList(
        data['customers'],
        LatLng(_properties.position!.latitude, _properties.position!.longitude),
      );
    }

    if (data['activeUser'] != null) {
      activeUser = UserDetail.fromJson(data['activeUser']);
    }

    if (data['currentPosition'] != null) {
      currentPosition = MapsLoc.fromJson(data['currentPosition']);
    }

    if (data['scheduleCount'] != null) {
      scheduleCount = data['scheduleCount'];
    }

    if (data['user'] != null) {
      AuthModel? authModel = await Get.find<AuthHelper>().get();
      if (authModel != null) {
        accounts = data['user'].map<UserDetail>((e) => UserDetail.fromJson(e)).toList();
        account = accounts.firstWhere((element) => element.userdtid == authModel.accountActive);
        accounts.removeWhere((element) => element.userdtid == authModel.accountActive);
      }
    }

    Get.find<TaskHelper>().loaderPop(DashboardString.taskCode);
  }

  @override
  void onLogoutError(String message) => _listener.onLogoutError(message);
  @override
  void onLogoutFailed(String message) => _listener.onLogoutFailed(message);
  @override
  void onLogoutSuccess(String message) => _listener.onLogoutSuccess(message);
}
