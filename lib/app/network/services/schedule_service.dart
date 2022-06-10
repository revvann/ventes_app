import 'package:get/get.dart';
import 'package:ventes/core/service.dart';

class ScheduleService extends Service {
  @override
  String get api => "/schedule";

  Future<Response> count(Map<String, dynamic> params) async {
    return await get('$api/count', query: params);
  }
}
