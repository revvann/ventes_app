import 'package:get/get.dart';
import 'package:ventes/core/api/service.dart';

class PlaceService extends Service {
  String place = '/country';
  @override
  String get api => place;

  PlaceService country() {
    place = '/country';
    return this;
  }

  PlaceService province() {
    place = '/province';
    return this;
  }

  PlaceService city() {
    place = '/city';
    return this;
  }

  PlaceService subdistrict() {
    place = '/subdistrict';
    return this;
  }

  Future<Response> byName(String name) {
    return get('$api/by-name', query: {'name': name});
  }
}
