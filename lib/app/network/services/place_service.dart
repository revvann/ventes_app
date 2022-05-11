import 'package:ventes/core/service.dart';

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
}
