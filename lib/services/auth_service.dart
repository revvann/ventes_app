import 'package:get/get.dart';
import 'package:ventes/services/regular_service.dart';

class AuthService extends RegularService {
  @override
  String get api => "/auth";

  Future<Response> signIn(Map<String, dynamic> credentials) async {
    return await post('$api/signin', credentials);
  }

  Future<Response> verify() async {
    return await get('/RJXvksjS');
  }
}
