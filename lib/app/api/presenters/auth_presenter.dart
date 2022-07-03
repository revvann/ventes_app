import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/auth_contract.dart';
import 'package:ventes/app/api/contracts/update_contract.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/services/auth_service.dart';

class AuthPresenter {
  final AuthService _authService = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();

  late AuthContract _authContract;
  set authContract(AuthContract contract) => _authContract = contract;
  late UpdateContract _updateContract;
  set updateContract(UpdateContract contract) => _updateContract = contract;

  void signIn(Map<String, dynamic> credentials) async {
    Map<String, dynamic> data = {};
    try {
      Response response = await _authService.signIn(credentials);
      if (response.statusCode == 200) {
        Map data = response.body;
        AuthModel authData = AuthModel(
          jwtToken: data['jwt_token'],
          userId: data['userid'],
          accountActive: data['userdetails'][0]['userdtid'],
          password: credentials['password'],
          username: credentials['username'],
        );
        Get.find<AuthHelper>().save(authData);

        data['message'] = "Welcome ${data['userfullname']}";
        data['user'] = data;
        _authContract.onAuthSuccess(data);
      } else {
        _authContract.onAuthFailed(response.body['message']);
      }
    } catch (e) {
      _authContract.onAuthFailed(e.toString());
    }
  }

  void attachDevice(int id, String userdeviceid) async {
    try {
      Response response = await _userService.attachDevice(id, userdeviceid);
      if (response.statusCode == 200) {
        _updateContract.onUpdateSuccess("Device attached successfully");
      } else {
        _updateContract.onUpdateFailed("Device attach failed");
      }
    } catch (e) {
      _updateContract.onUpdateFailed(e.toString());
    }
    _updateContract.onUpdateComplete();
  }
}
