import 'package:ventes/app/network/services/regular_service.dart';

class PlaceServices extends RegularService {
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
