import 'dart:convert';

import 'package:get/get.dart';
import 'package:ventes/network/contracts/auth_contract.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/network/services/auth_service.dart';

class AuthPresenter {
  final AuthService _authService = Get.find<AuthService>();
  late AuthContract _authContract;
  set authContract(AuthContract contract) => _authContract = contract;

  void signIn(Map<String, dynamic> credentials) async {
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

        String message = "Welcome ${data['userfullname']}";
        _authContract.onAuthSuccess(message);
      } else {
        _authContract.onAuthFailed(response.body['message']);
      }
    } catch (err) {
      _authContract.onAuthFailed(err.toString());
    }
  }
}
