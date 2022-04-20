import 'package:get/get.dart';
import 'package:ventes/constants/strings/regular_string.dart';

class GmapsService extends GetConnect {
  Future<Response> getDetail(double latitude, double longitude) async {
    return await get('https://maps.googleapis.com/maps/api/geocode/json', query: {
      "latlng": "$latitude,$longitude",
      "key": RegularString.gmapsKey,
    });
  }
}
