// ignore_for_file: unnecessary_getters_setters, prefer_const_constructors

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
    httpClient.timeout = Duration(hours: 5);
  }

  Future<Response> select([Map<String, dynamic>? params]) {
    return get(api, query: params);
  }

  Future<Response> store(
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    return post(api, body, contentType: contentType, headers: headers, query: query);
  }

  Future<Response> show(int id) {
    return get('$api/$id');
  }

  Future<Response> update(
    int id,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    return put('$api/$id', body, contentType: contentType, headers: headers, query: query);
  }

  Future<Response> postUpdate(
    int id,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    return post('$api/$id', body, contentType: contentType, headers: headers, query: query);
  }

  Future<Response> destroy(int id, {Map<String, dynamic>? query}) {
    return delete('$api/$id', query: query);
  }
}
