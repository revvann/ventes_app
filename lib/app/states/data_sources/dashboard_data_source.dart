import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/dashboard_presenter.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';

class DashboardDataSource extends StateDataSource<DashboardPresenter> with DataSourceMixin implements DashboardContract {
  final _customers = Rx<List<BpCustomer>>([]);
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

  final _currentPosition = Rx<MapsLoc?>(null);
  MapsLoc? get currentPosition => _currentPosition.value;
  set currentPosition(MapsLoc? value) => _currentPosition.value = value;

  void fetchData(LatLng position) => presenter.fetchData(position.latitude, position.longitude);
  void logout() => presenter.logout();

  void _customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers.map((element) => _filterBpCustomer(element, coords2)).where(_isBpCustomer100Meters).toList();
  }

  BpCustomer _filterBpCustomer(BpCustomer element, LatLng currentCoordinates) {
    LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
    double radius = calculateDistance(coords1, currentCoordinates);
    element.radius = radius;
    return element;
  }

  bool _isBpCustomer100Meters(BpCustomer element) => element.radius != null ? element.radius! <= 100 : false;

  @override
  DashboardPresenter presenterBuilder() => DashboardPresenter();

  @override
  onLoadError(String message) => listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) async {
    if (data['customers'] != null) {
      _customersFromList(
        data['customers'],
        LatLng(property.position!.latitude, property.position!.longitude),
      );
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
  }

  @override
  void onLogoutError(String message) => listener.onLogoutError(message);
  @override
  void onLogoutFailed(String message) => listener.onLogoutFailed(message);
  @override
  void onLogoutSuccess(String message) => listener.onLogoutSuccess(message);

  @override
  onLoadComplete() => listener.onComplete();

  @override
  void onLogoutComplete() => listener.onComplete();
}
