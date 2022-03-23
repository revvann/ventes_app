import 'dart:convert';

import 'package:get/get.dart';
import 'package:ventes/contracts/auth_contract.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/models/auth_model.dart';
import 'package:ventes/services/auth_service.dart';

class AuthPresenter {
  final AuthService _authService = Get.find<AuthService>();
  late AuthContract _authContract;
  set authContract(AuthContract contract) => _authContract = contract;

  void signIn(String username, String password) async {
    try {
      Response response = await _authService.signIn(username, password);
      if (response.statusCode == 200) {
        Map data = response.body;
        AuthModel authData = AuthModel(
          jwtToken: data['jwt_token'],
          userId: data['userid'],
        );
        Get.find<AuthHelper>().save(authData);

        String message = "Welcome ${data['userfullname']}";
        _authContract.onAuthSuccess(message);
      } else {
        _authContract.onAuthFailed(response.body['message']);
      }
    } catch (err) {
      _authContract.onAuthSuccess(err.toString());
    }
  }
}
