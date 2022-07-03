import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/place_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/city_model.dart';
import 'package:ventes/app/api/models/country_model.dart';
import 'package:ventes/app/api/models/province_model.dart';
import 'package:ventes/app/api/models/subdistrict_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class CustomerFormUpdatePresenter extends RegularPresenter {
  final PlaceService _placeService = Get.find<PlaceService>();
  final BpCustomerService _bpCustomerService = Get.find<BpCustomerService>();
  final CustomerService _customerService = Get.find<CustomerService>();
  final UserService _userService = Get.find<UserService>();
  final TypeService _typeService = Get.find<TypeService>();

  Future<Response> _getBpCustomers() async {
    int? bpid = (await _findActiveUser())?.userdtbpid;
    Map<String, dynamic> data = {
      'sbcbpid': bpid.toString(),
    };
    return await _bpCustomerService.select(data);
  }

  Future<Response> _getCustomers() async {
    return await _customerService.select();
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

  Future<Response> _getStatuses() async {
    return await _typeService.byCode({'typecd': NearbyString.statusTypeCode});
  }

  SimpleFetcher<List> get fetchBpCustomers => SimpleFetcher(
        responseBuilder: _getBpCustomers,
        failedMessage: NearbyString.fetchFailed,
      );

  SimpleFetcher<List> get fetchCustomers => SimpleFetcher(
        responseBuilder: _getCustomers,
        failedMessage: NearbyString.fetchFailed,
      );

  SimpleFetcher<List> get fetchTypes => SimpleFetcher(
        responseBuilder: _getTypes,
        failedMessage: NearbyString.fetchFailed,
      );

  SimpleFetcher<List> get fetchStatuses => SimpleFetcher(
        responseBuilder: _getStatuses,
        failedMessage: NearbyString.fetchFailed,
      );

  DataFetcher<Function(int), Map<String, dynamic>> get fetchBpCustomer => DataFetcher(
        builder: (handler) {
          return (id) async {
            handler.start();
            try {
              Response bpcustomerReponse = await _bpCustomerService.show(id);
              if (bpcustomerReponse.statusCode == 200) {
                BpCustomer bpCustomer = BpCustomer.fromJson(bpcustomerReponse.body);

                Response provinceResponse = await _placeService.province().show(bpCustomer.sbccstm?.cstmprovinceid ?? 0);
                if (provinceResponse.statusCode == 200) {
                  bpCustomer.sbccstm?.cstmprovince = Province.fromJson(provinceResponse.body);
                }

                Response countryResponse = await _placeService.country().show(bpCustomer.sbccstm?.cstmprovince?.provcountryid ?? 0);
                if (countryResponse.statusCode == 200) {
                  bpCustomer.sbccstm?.cstmcountry = Country.fromJson(countryResponse.body);
                }

                Response cityResponse = await _placeService.city().show(bpCustomer.sbccstm?.cstmcityid ?? 0);
                if (cityResponse.statusCode == 200) {
                  bpCustomer.sbccstm?.cstmcity = City.fromJson(cityResponse.body);
                }

                Response subdistrictResponse = await _placeService.subdistrict().show(bpCustomer.sbccstm?.cstmsubdistrictid ?? 0);
                if (subdistrictResponse.statusCode == 200) {
                  bpCustomer.sbccstm?.cstmsubdistrict = Subdistrict.fromJson(subdistrictResponse.body);
                }

                handler.success(bpCustomer.toJson());
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

  DataFetcher<Function(int, FormData), String> get update => DataFetcher(
        builder: (handler) {
          return (id, data) async {
            handler.start();
            try {
              Response response = await _bpCustomerService.postUpdate(
                id,
                data,
                contentType: "multipart/form-data",
              );
              if (response.statusCode == 200) {
                handler.success(NearbyString.updateSuccess);
              } else {
                handler.failed(NearbyString.updateFailed);
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
