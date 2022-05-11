// ignore_for_file: unnecessary_getters_setters

import 'package:get/get.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/models/auth_model.dart';

class Service extends GetConnect {
  String get api => '';

  @override
  void onInit() {
    httpClient.baseUrl = RegularString.api;
    httpClient.addRequestModifier<dynamic>((request) async {
      AuthModel? session = await Get.find<AuthHelper>().get();
      if (session?.jwtToken != null) request.headers['Authorization'] = "Bearer ${session?.jwtToken}";
      return request;
    });
    httpClient.timeout = Duration(seconds: 30);
  }

  Future<Response> select(Map<String, dynamic> params) {
    return get(api, query: params);
  }

  Future<Response> store(Map<String, dynamic> body) {
    return post(api, body);
  }

  Future<Response> show(int id) {
    return get('$api/$id');
  }

  Future<Response> update(int id, Map<String, dynamic> body) {
    return put('$api/$id', body);
  }

  Future<Response> destroy(int id, {Map<String, dynamic>? query}) {
    return delete('$api/$id', query: query);
  }
}
