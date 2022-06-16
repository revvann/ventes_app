import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/delete_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/customer_service.dart';
import 'package:ventes/app/network/services/gmaps_service.dart';
import 'package:ventes/app/network/services/place_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class NearbyPresenter extends RegularPresenter<NearbyContract> {
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

  void fetchData(double latitude, double longitude) async {
    Map data = {};
    Response locResponse = await _getLocDetail(latitude, longitude);
    Response bpCustomersResponse = await _getBpCustomers();
    try {
      if (locResponse.statusCode == 200 && bpCustomersResponse.statusCode == 200) {
        data['location'] = locResponse.body;
        data['bpcustomers'] = bpCustomersResponse.body;

        MapsLoc location = MapsLoc.fromJson(locResponse.body);
        String subdistrict =
            location.adresses!.first.addressComponents!.firstWhere((element) => element.types!.contains('administrative_area_level_3')).longName!.replaceAll(RegExp(r'Kecamatan |Kec '), '');
        Response subdistrictResponse = await _getSubdistrict(subdistrict);
        if (subdistrictResponse.statusCode == 200) {
          Subdistrict subdistrictModel = Subdistrict.fromJson(subdistrictResponse.body);
          Response customersResponse = await _getCustomers(subdistrictModel.subdistrictid!);
          if (customersResponse.statusCode == 200) {
            data['customers'] = customersResponse.body;
            contract.onLoadSuccess(data);
          }
        }
      } else {
        contract.onLoadFailed(NearbyString.fetchFailed);
      }
    } catch (err) {
      contract.onLoadError(err.toString());
    }
  }

  void deleteData(int id) async {
    try {
      Response response = await _bpCustomerService.destroy(id);
      if (response.statusCode == 200) {
        contract.onDeleteSuccess(NearbyString.deleteSuccess);
      } else {
        contract.onDeleteFailed(NearbyString.deleteFailed);
      }
    } catch (e) {
      contract.onDeleteError(e.toString());
    }
  }
}

abstract class NearbyContract implements FetchDataContract, DeleteContract {}
