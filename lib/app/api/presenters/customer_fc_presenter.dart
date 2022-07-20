import 'package:get/get.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/village_model.dart';
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

class CustomerFormCreatePresenter extends RegularPresenter {
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

  Future<Response> _getPlacesByName(String village, String subdistrict, String city, String province) async {
    return await _placeService.village().placesByName(village, subdistrict, city, province);
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
            try {
              Response locResponse = await _getLocDetail(latitude, longitude);
              if (locResponse.statusCode == 200) {
                handler.success(locResponse.body);
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

  DataFetcher<Function(String, String, String, String), Map<String, dynamic>> get fetchPlaces => DataFetcher(
        builder: (handler) {
          return (village, subdistrict, city, province) async {
            handler.start();
            try {
              Map<String, dynamic> data = {};
              Response placesResponse = await _getPlacesByName(village, subdistrict, city, province);

              if (placesResponse.statusCode == 200) {
                Village village = Village.fromJson(List<Map<String, dynamic>>.from(placesResponse.body).firstWhereOrNull((element) => true) ?? {});
                data['province'] = village.villagesubdistrict?.subdistrictcity?.cityprov?.toJson();
                data['city'] = village.villagesubdistrict?.subdistrictcity?.toJson();
                data['subdistrict'] = village.villagesubdistrict?.toJson();
                data['village'] = village.toJson();
                handler.success(data);
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
}
