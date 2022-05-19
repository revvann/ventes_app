import 'package:get/get.dart';
import 'package:ventes/core/service.dart';

class AuthService extends Service {
  @override
  String get api => "/auth";

  Future<Response> signIn(Map<String, dynamic> credentials) async {
    return await post('$api/signin', credentials);
  }

  Future<Response> signOut() async {
    return await get('/pIeYujTv');
  }

  Future<Response> verify() async {
    return await get('/RJXvksjS');
  }
}
