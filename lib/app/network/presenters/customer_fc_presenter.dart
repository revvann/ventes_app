import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/customer_service.dart';
import 'package:ventes/app/network/services/gmaps_service.dart';
import 'package:ventes/app/network/services/place_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class CustomerFormCreatePresenter {
  final PlaceService _placeService = Get.find<PlaceService>();
  final BpCustomerService _bpCustomerService = Get.find<BpCustomerService>();
  final CustomerService _customerService = Get.find<CustomerService>();
  final UserService _userService = Get.find<UserService>();
  final TypeService _typeService = Get.find<TypeService>();
  final GmapsService _gmapsService = Get.find<GmapsService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late CreateContract _createContract;
  set createContract(CreateContract value) => _createContract = value;

  Future<Response> _getCustomers() async {
    return await _customerService.select();
  }

  Future<Response> _getCustomer(int id) async {
    return await _customerService.show(id);
  }

  Future<Response> _getUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  Future<Response> _getLocDetail(double latitude, double longitude) async {
    return await _gmapsService.getDetail(latitude, longitude);
  }

  Future<Response> _getProvince(int idProv) async {
    return await _placeService.province().show(idProv);
  }

  Future<Response> _getCity(int idCity) async {
    return await _placeService.city().show(idCity);
  }

  Future<Response> _getSubdistrict(String name) async {
    return await _placeService.subdistrict().byName(name);
  }

  Future<UserDetail?> _findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': NearbyString.customerTypeCode});
  }

  Future<Response> _getStatusTypes() async {
    return await _typeService.byCode({'typecd': NearbyString.statusTypeCode});
  }

  void fetchData(double latitude, double longitude, [int? cstmid]) async {
    Map data = {};
    try {
      Response userResponse = await _getUser();
      Response customersResponse = await _getCustomers();
      Response typeResponse = await _getTypes();
      Response statusResponse = await _getStatusTypes();

      if (cstmid != null) {
        Response customerResponse = await _getCustomer(cstmid);
        if (customerResponse.statusCode == 200) {
          Customer customer = Customer.fromJson(customerResponse.body);
          Response subdistrictResponse = await _getSubdistrict(customer.cstmsubdistrict?.subdistrictname ?? "");

          if (subdistrictResponse.statusCode == 200) {
            Subdistrict subdistrict = Subdistrict.fromJson(subdistrictResponse.body ?? {});
            Response cityResponse = await _getCity(subdistrict.subdistrictcityid ?? 0);

            if (cityResponse.statusCode == 200) {
              City city = City.fromJson(cityResponse.body);
              Response provinceResponse = await _getProvince(city.cityprovid ?? 0);

              if (provinceResponse.statusCode == 200) {
                // // add country to customer (mscustomer doesnt have countryid field)
                customer.cstmcountry = Province.fromJson(provinceResponse.body).provcountry;

                data['places'] = {};
                data['places']['province'] = provinceResponse.body;
                data['places']['city'] = cityResponse.body;
                data['places']['subdistrict'] = subdistrict.toJson();
                data['customer'] = customer.toJson();
              }
            }
          }
        }
      } else {
        Response locResponse = await _getLocDetail(latitude, longitude);
        if (locResponse.statusCode == 200) {
          data['location'] = locResponse.body;
        }
      }

      if (customersResponse.statusCode == 200 && typeResponse.statusCode == 200 && statusResponse.statusCode == 200 && userResponse.statusCode == 200) {
        data['customers'] = customersResponse.body;
        data['types'] = typeResponse.body;
        data['statuses'] = statusResponse.body;
        data['user'] = userResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(NearbyString.fetchFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  void fetchPlaces(String subdistrictSearch) async {
    Map data = {'places': {}};

    try {
      Response subdistrictResponse = await _getSubdistrict(subdistrictSearch);
      if (subdistrictResponse.statusCode == 200) {
        Subdistrict subdistrict = Subdistrict.fromJson(subdistrictResponse.body ?? {});
        Response cityResponse = await _getCity(subdistrict.subdistrictcityid ?? 0);

        if (cityResponse.statusCode == 200) {
          City city = City.fromJson(cityResponse.body);
          Response provinceResponse = await _getProvince(city.cityprovid ?? 0);

          if (provinceResponse.statusCode == 200) {
            data['places']['province'] = provinceResponse.body;
            data['places']['city'] = cityResponse.body;
            data['places']['subdistrict'] = subdistrict.toJson();
            _fetchDataContract.onLoadSuccess(data);
          }
        } else {
          _fetchDataContract.onLoadFailed(NearbyString.fetchFailed);
        }
      } else {
        _fetchDataContract.onLoadFailed(NearbyString.fetchFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  void createCustomer(FormData data) async {
    try {
      Response response = await _bpCustomerService.store(
        data,
        contentType: "multipart/form-data",
      );
      if (response.statusCode == 200) {
        _createContract.onCreateSuccess(NearbyString.createSuccess);
      } else {
        _createContract.onCreateFailed(NearbyString.createFailed);
      }
    } catch (err) {
      _createContract.onCreateError(err.toString());
    }
  }

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
