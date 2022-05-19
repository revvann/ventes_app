import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/logout_contract.dart';
import 'package:ventes/app/network/presenters/dashboard_presenter.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/states/listeners/dashboard_listener.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardDataSource implements FetchDataContract, LogoutContract {
  DashboardProperties get _properties => Get.find<DashboardProperties>();
  DashboardListener get _listener => Get.find<DashboardListener>();

  final DashboardPresenter _presenter = DashboardPresenter();

  final _customers = <BpCustomer>[].obs;
  set customers(List<BpCustomer> value) => _customers.value = value;
  List<BpCustomer> get customers => _customers.value;

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
  onLoadError(String message) => _listener.onLoadDataError();

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed();

  @override
  onLoadSuccess(Map data) {
    if (data['customers'] != null) {
      customersFromList(
        data['customers'],
        LatLng(_properties.position!.latitude, _properties.position!.longitude),
      );
    }
    Get.find<TaskHelper>().remove(DashboardString.taskCode);
  }

  @override
  void onLogoutError(String message) => _listener.onLogoutError(message);
  @override
  void onLogoutFailed(String message) => _listener.onLogoutFailed(message);
  @override
  void onLogoutSuccess(String message) => _listener.onLogoutSuccess(message);
}
