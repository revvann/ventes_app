import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/place_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class CustomerFormCreatePresenter {
  final PlaceService _placeService = Get.find<PlaceService>();
  final BpCustomerService _bpCustomerService = Get.find<BpCustomerService>();
  final UserService _userService = Get.find<UserService>();
  final TypeService _typeService = Get.find<TypeService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late CreateContract _createContract;
  set createContract(CreateContract value) => _createContract = value;

  Future<Response> _getCustomers() async {
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

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': NearbyString.customerTypeCode});
  }

  void fetchData() async {
    Map data = {};
    try {
      AuthModel? authModel = await Get.find<AuthHelper>().get();
      Response userResponse = await _userService.show(authModel!.accountActive!);
      Response customerResponse = await _getCustomers();
      Response typeResponse = await _getTypes();
      if (customerResponse.statusCode == 200) {
        data['customers'] = customerResponse.body;
        data['types'] = typeResponse.body;
        data['user'] = userResponse.body;
        _fetchDataContract.onLoadSuccess(data);
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
