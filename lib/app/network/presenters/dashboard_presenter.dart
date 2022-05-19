import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/logout_contract.dart';
import 'package:ventes/app/network/services/auth_service.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class DashboardPresenter {
  final _bpCustomerService = Get.find<BpCustomerService>();
  final _userService = Get.find<UserService>();
  final _authService = Get.find<AuthService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late LogoutContract _logoutContract;
  set logoutContract(LogoutContract value) => _logoutContract = value;

  Future<Response> _getCustomers() async {
    int? bpid = (await _findActiveUser())?.userdtbpid;
    Map<String, dynamic> data = {
      'sbcbpid': bpid.toString(),
    };
    return await _bpCustomerService.select(data);
  }

  Future<UserDetail?> _findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  void fetchData(double latitude, double longitude) async {
    Map data = {};
    Response customersResponse = await _getCustomers();
    try {
      if (customersResponse.statusCode == 200) {
        data['customers'] = customersResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(NearbyString.fetchFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  void logout() async {
    Response authResponse = await _authService.signOut();
    try {
      if (authResponse.statusCode == 200) {
        _logoutContract.onLogoutSuccess("Logout Success");
      } else {
        _logoutContract.onLogoutFailed("Logout Failed");
      }
    } catch (err) {
      _logoutContract.onLogoutError(err.toString());
    }
  }
}
