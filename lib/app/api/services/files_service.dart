import 'package:get/get.dart';
import 'package:ventes/core/api/service.dart';

class FilesService extends Service {
  @override
  String get api => "/files";

  Future<Response> download(int id) async {
    return await get(
      '$api/download/$id',
    );
  }
}
