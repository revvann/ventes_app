import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/place_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/maps_loc.dart';
import 'package:ventes/app/api/models/subdistrict_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class NearbyPresenter extends RegularPresenter {
  final GmapsService _gmapsService = Get.find();
  final BpCustomerService _bpCustomerService = Get.find();
  final PlaceService _placeService = Get.find();
  final CustomerService _customerService = Get.find();
  final UserService _userService = Get.find();

  Future<Response> _getSubdistrict(String name) async {
    return await _placeService.subdistrict().byName(name);
  }

  Future<Response> _getLocDetail(double latitude, double longitude) async {
    return await _gmapsService.getDetail(latitude, longitude);
  }

  Future<Response> _getCustomers(int id) async {
    Map<String, dynamic> params = {
      'cstmsubdistrictid': id.toString(),
    };
    return await _customerService.select(params);
  }

  Future<Response> _getBpCustomers() async {
    int? bpid = (await _findActiveUser())?.userdtbpid;
    Map<String, dynamic> data = {
      'sbcbpid': bpid.toString(),
    };
    return await _bpCustomerService.select(data);
  }

  Future<UserDetail?> _findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  DataFetcher<Function(int), String> get delete => DataFetcher(
        builder: (handler) {
          return (int id) async {
            handler.start();
            try {
              Response response = await _bpCustomerService.destroy(id);
              if (response.statusCode == 200) {
                handler.success(NearbyString.deleteSuccess);
              } else {
                handler.failed(NearbyString.deleteFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  DataFetcher<Future Function(double, double), Map<String, dynamic>> get fetchLocation => DataFetcher(
        builder: (handler) {
          return (double latitude, double longitude) async {
            handler.start();
            try {
              Response response = await _getLocDetail(latitude, longitude);
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

  SimpleFetcher<List> get fetchBpCustomers => SimpleFetcher(
        responseBuilder: _getBpCustomers,
        failedMessage: NearbyString.fetchFailed,
      );

  DataFetcher<Future Function(String), List> get fetchCustomers => DataFetcher(
        builder: (handler) {
          return (String subdistrict) async {
            handler.start();
            try {
              Response subdistrictResponse = await _getSubdistrict(subdistrict);

              if (subdistrictResponse.statusCode == 200) {
                Subdistrict subdistrictModel = Subdistrict.fromJson(subdistrictResponse.body);
                Response customersResponse = await _getCustomers(subdistrictModel.subdistrictid!);
                if (customersResponse.statusCode == 200) {
                  handler.success(customersResponse.body);
                } else {
                  handler.failed(NearbyString.fetchFailed);
                }
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  Future<MapsLoc?> fetchLocationDetail(double latitude, double longitude) async {
    MapsLoc? location;
    try {
      Response response = await _getLocDetail(latitude, longitude);
      if (response.statusCode == 200) {
        location = MapsLoc.fromJson(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return location;
  }
}
