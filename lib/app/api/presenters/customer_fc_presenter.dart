import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/api/contracts/create_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/place_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class CustomerFormCreatePresenter extends RegularPresenter<CustomerCreateContract> {
  final PlaceService _placeService = Get.find();
  final BpCustomerService _bpCustomerService = Get.find();
  final CustomerService _customerService = Get.find();
  final UserService _userService = Get.find();
  final TypeService _typeService = Get.find();
  final GmapsService _gmapsService = Get.find();

  Future<Response> _getCustomers([Map<String, dynamic> params = const {}]) async {
    return await _customerService.select(params);
  }

  Future<Response> _getBpCustomers([Map<String, dynamic> params = const {}]) async {
    return await _bpCustomerService.select(params);
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

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': NearbyString.customerTypeCode});
  }

  Future<Response> _getStatusTypes() async {
    return await _typeService.byCode({'typecd': NearbyString.statusTypeCode});
  }

  SimpleFetcher<Map<String, dynamic>> get fetchUser => SimpleFetcher(responseBuilder: _getUser, failedMessage: NearbyString.fetchFailed);
  SimpleFetcher<List> get fetchCustomers => SimpleFetcher(responseBuilder: _getCustomers, failedMessage: NearbyString.fetchFailed);
  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes, failedMessage: NearbyString.fetchFailed);
  SimpleFetcher<List> get fetchStatuses => SimpleFetcher(responseBuilder: _getStatusTypes, failedMessage: NearbyString.fetchFailed);

  DataFetcher<Function(double, double), Map<String, dynamic>> get fetchLocation => DataFetcher(
        builder: (handler) {
          return (latitude, longitude) async {
            handler.start();
            // try {
            Response locResponse = await _getLocDetail(latitude, longitude);
            if (locResponse.statusCode == 200) {
              handler.success(locResponse.body);
            } else {
              handler.failed(NearbyString.fetchFailed);
            }
            // } catch (e) {
            //   handler.error(e.toString());
            // }
            handler.complete();
          };
        },
      );

  DataFetcher<Function(String), Map<String, dynamic>> get fetchPlaces => DataFetcher(
        builder: (handler) {
          return (subdistrictname) async {
            handler.start();
            try {
              Map<String, dynamic> data = {};
              Response subdistrictResponse = await _getSubdistrict(subdistrictname);

              if (subdistrictResponse.statusCode == 200) {
                Subdistrict subdistrict = Subdistrict.fromJson(subdistrictResponse.body ?? {});
                Response cityResponse = await _getCity(subdistrict.subdistrictcityid ?? 0);

                if (cityResponse.statusCode == 200) {
                  City city = City.fromJson(cityResponse.body);
                  Response provinceResponse = await _getProvince(city.cityprovid ?? 0);

                  if (provinceResponse.statusCode == 200) {
                    data['province'] = provinceResponse.body;
                    data['city'] = cityResponse.body;
                    data['subdistrict'] = subdistrictResponse.body;
                    handler.success(data);
                  } else {
                    handler.failed(NearbyString.fetchFailed);
                  }
                } else {
                  handler.failed(NearbyString.fetchFailed);
                }
              } else {
                handler.failed(NearbyString.fetchFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  DataFetcher<Function(int), Map<String, dynamic>> get fetchCustomer => DataFetcher(
        builder: (handler) {
          return (cstmid) async {
            handler.start();
            try {
              Response response = await _getCustomer(cstmid);
              if (response.statusCode == 200) {
                handler.success(response.body);
              } else {
                handler.failed(NearbyString.fetchFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  DataFetcher<Function(int), List> get fetchNearbyCustomers => DataFetcher(
        builder: (handler) {
          return (subdistrictid) async {
            handler.start();
            try {
              Response customerResponse = await _getCustomers({
                'cstmsubdistrictid': subdistrictid.toString(),
              });

              if (customerResponse.statusCode == 200) {
                handler.success(customerResponse.body);
              } else {
                handler.failed(NearbyString.fetchFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  DataFetcher<Function(int), List> get fetchBpCustomers => DataFetcher(builder: (handler) {
        return (customerid) async {
          handler.start();
          try {
            AuthModel? authModel = await Get.find<AuthHelper>().get();
            Response bpCustomerResponse = await _getBpCustomers({
              'sbccstmid': customerid.toString(),
              'sbcbpid': authModel?.accountActive?.toString(),
            });

            if (bpCustomerResponse.statusCode == 200) {
              handler.success(bpCustomerResponse.body);
            } else {
              handler.failed(NearbyString.fetchFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });

  DataFetcher<Function(FormData), String> get create => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _bpCustomerService.store(
                data,
                contentType: "multipart/form-data",
              );
              if (response.statusCode == 200) {
                handler.success(NearbyString.createSuccess);
              } else {
                handler.failed(NearbyString.createFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

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

abstract class CustomerCreateContract implements FetchDataContract, CreateContract {}
