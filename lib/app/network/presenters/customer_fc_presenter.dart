import 'package:get/get.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/network/services/place_service.dart';

class CustomerFormCreatePresenter {
  final PlaceService _placeService = Get.find<PlaceService>();

  Future<List<Country>> fetchCountries([String? search]) async {
    Map<String, dynamic> params = {
      'search': search,
    };

    Response response = await _placeService.country().select(params);
    if (response.statusCode == 200) {
      return List<Country>.from(response.body.map((item) => Country.fromJson(item)));
    }
    return [];
  }

  Future<List<Province>> fetchProvinces(int countryId, [String? search]) async {
    Map<String, dynamic> params = {
      'search': search,
      'provcountryid': countryId.toString(),
    };

    Response response = await _placeService.province().select(params);
    if (response.statusCode == 200) {
      return List<Province>.from(response.body.map((item) => Province.fromJson(item)));
    }
    return [];
  }

  Future<List<City>> fetchCities(int provinceId, [String? search]) async {
    Map<String, dynamic> params = {
      'search': search,
      'cityprovid': provinceId.toString(),
    };

    Response response = await _placeService.city().select(params);
    if (response.statusCode == 200) {
      return List<City>.from(response.body.map((item) => City.fromJson(item)));
    }
    return [];
  }

  Future<List<Subdistrict>> fetchSubdistricts(int cityId, [String? search]) async {
    Map<String, dynamic> params = {
      'search': search,
      'subdistrictcityid': cityId.toString(),
    };

    Response response = await _placeService.subdistrict().select(params);
    if (response.statusCode == 200) {
      return List<Subdistrict>.from(response.body.map((item) => Subdistrict.fromJson(item)));
    }
    return [];
  }
}
