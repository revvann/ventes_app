import 'package:get/get.dart';
import 'package:ventes/services/regular_service.dart';

class AuthService extends RegularService {
  @override
  String get api => "/auth";

  Future<Response> signIn(String username, String password) async {
    return await post('$api/signin', {
      "username": username,
      "password": password,
    });
  }
}
