import 'package:get_storage/get_storage.dart';
import 'package:ventes/models/auth_model.dart';

class AuthHelper {
  static const String container = "VentesAuth";
  static const String idKey = "userId";
  static const String tokenKey = "jwtToken";

  static Future<bool> save(AuthModel authModel) async {
    GetStorage storage = GetStorage(AuthHelper.container);
    await storage.write(AuthHelper.idKey, authModel.userId);
    await storage.write(AuthHelper.tokenKey, authModel.jwtToken);
    return check();
  }

  static bool check() {
    GetStorage storage = GetStorage(AuthHelper.container);
    return storage.hasData(AuthHelper.tokenKey);
  }

  static Future<AuthModel?> get() async {
    GetStorage storage = GetStorage(AuthHelper.container);
    if (check()) {
      int userId = await storage.read(AuthHelper.idKey);
      String jwtToken = await storage.read(AuthHelper.tokenKey);
      return AuthModel(userId: userId, jwtToken: jwtToken);
    }
    return null;
  }

  static Future<bool> destroy() async {
    GetStorage storage = GetStorage(AuthHelper.container);
    await storage.remove(AuthHelper.idKey);
    await storage.remove(AuthHelper.tokenKey);
    return check();
  }
}
