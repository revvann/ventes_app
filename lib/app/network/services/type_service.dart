import 'package:get/get.dart';
import 'package:ventes/core/service.dart';

class TypeService extends Service {
  @override
  String get api => "/types";

  ///
  /// params must has typecd key
  ///
  Future<Response> byCode(Map<String, dynamic> params) async {
    return await get('$api/by-code', query: params);
  }
}
