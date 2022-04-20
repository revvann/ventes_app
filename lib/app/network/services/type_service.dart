import 'package:get/get.dart';
import 'package:ventes/app/network/services/regular_service.dart';

class TypeService extends RegularService {
  @override
  String get api => "/types";

  Future<Response> byCode(Map<String, dynamic> params) async {
    return await get('$api/by-code', query: params);
  }
}
