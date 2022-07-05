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

  PlaceService village() {
    place = '/village';
    return this;
  }

  Future<Response> byName(String name) {
    return get('$api/by-name', query: {'name': name});
  }

  Future<Response> placesByName(String village, String subdistrict, String city, String province) {
    return get('$api/by-name', query: {
      'village': village,
      'subdistrict': subdistrict,
      'city': city,
      'province': province,
    });
  }
}
