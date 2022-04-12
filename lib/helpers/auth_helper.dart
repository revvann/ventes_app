import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ventes/models/auth_model.dart';
import 'package:ventes/services/auth_service.dart';
import 'package:ventes/services/user_service.dart';

class AuthHelper {
  final _authService = Get.find<AuthService>();

  static GetStorage get container => GetStorage("VentesAuth");
  static const String idKey = "userId";
  static const String tokenKey = "jwtToken";
  static const String accountKey = "accountActive";
  static const String passwordKey = "password";
  static const String usernameKey = "username";
  static var userId = ReadWriteValue<int?>(AuthHelper.idKey, null, () => AuthHelper.container);
  static var jwtToken = ReadWriteValue<String?>(AuthHelper.tokenKey, null, () => AuthHelper.container);
  static var accountActive = ReadWriteValue<int?>(AuthHelper.accountKey, null, () => AuthHelper.container);
  static var username = ReadWriteValue<String?>(AuthHelper.usernameKey, null, () => AuthHelper.container);
  static var password = ReadWriteValue<String?>(AuthHelper.passwordKey, null, () => AuthHelper.container);

  Future<bool> save(AuthModel authModel) async {
    userId.val = authModel.userId;
    jwtToken.val = authModel.jwtToken;
    accountActive.val = authModel.accountActive;
    username.val = authModel.username;
    password.val = authModel.password;
    return check();
  }

  bool check() {
    return userId.val != null && accountActive.val != null && username.val != null && password.val != null;
  }

  Future retry() async {
    if (check()) {
      Map<String, dynamic> credentials = {
        'username': username.val,
        'password': password.val,
      };
      Response response = await _authService.signIn(credentials);
      if (response.statusCode == 200) {
        jwtToken.val = response.body['jwt_token'];
      }
    }
  }

  Future<bool> verifyToken() async {
    if (check()) {
      Response response = await _authService.verify();
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  Future<AuthModel?> get() async {
    if (check()) {
      int? _userId = userId.val;
      String? _jwtToken = jwtToken.val;
      int? _accountActive = accountActive.val;
      String? _username = username.val;
      String? _password = password.val;
      return AuthModel(
        userId: _userId,
        jwtToken: _jwtToken,
        accountActive: _accountActive,
        username: _username,
        password: _password,
      );
    }
    return null;
  }

  Future<bool> destroy() async {
    userId.val = null;
    jwtToken.val = null;
    username.val = null;
    password.val = null;
    return check();
  }
}
