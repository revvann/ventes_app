import 'package:ventes/core/service.dart';

class PlaceServices extends Service {
  country() {
    api = '/country';
  }

  void province() {
    api = '/province';
  }

  void city() {
    api = '/city';
  }

  void subdistrict() {
    api = '/subdistrict';
  }
}
