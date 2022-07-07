import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/services/auth_service.dart';

class AuthHelper {
  final _authService = Get.find<AuthService>();

  GetStorage get container => GetStorage("VentesAuth");
  String idKey = "userId";
  String tokenKey = "jwtToken";
  String accountKey = "accountActive";
  String passwordKey = "password";
  String usernameKey = "username";
  ReadWriteValue<int?> get userId => ReadWriteValue<int?>(idKey, null, () => container);
  ReadWriteValue<String?> get jwtToken => ReadWriteValue<String?>(tokenKey, null, () => container);
  ReadWriteValue<int?> get accountActive => ReadWriteValue<int?>(accountKey, null, () => container);
  ReadWriteValue<String?> get username => ReadWriteValue<String?>(usernameKey, null, () => container);
  ReadWriteValue<String?> get password => ReadWriteValue<String?>(passwordKey, null, () => container);

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
        userId.val = response.body['userid'];
        accountActive.val = response.body['userdetails'].first['userdtid'];
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
    accountActive.val = null;
    jwtToken.val = null;
    username.val = null;
    password.val = null;
    return check();
  }
}
