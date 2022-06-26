import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/customer_fc_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';

class CustomerFormCreateDataSource extends StateDataSource<CustomerFormCreatePresenter> with DataSourceMixin {
  final String userID = "usrhdr";
  final String customersID = 'custshdr';
  final String statusesID = 'stsshdr';
  final String typesID = 'typshdr';
  final String locationID = 'locationhdr';
  final String placesID = 'placeshdr';
  final String customerID = 'custohdr';
  final String nearbyCustomersID = 'nearcusthdr';
  final String bpCustomersID = 'bpcustomerid';
  final String createID = 'create';

  late DataHandler<dynamic, Map<String, dynamic>, Function()> userHandler;
  late DataHandler<List<BpCustomer>, List, Function()> customersHandler;
  late DataHandler<Map<int, String>, List, Function()> statusesHandler;
  late DataHandler<Map<int, String>, List, Function()> typesHandler;
  late DataHandler<MapsLoc?, Map<String, dynamic>, Function(double, double)> locationHandler;
  late DataHandler<dynamic, Map<String, dynamic>, Function(String)> placesHandler;
  late DataHandler<Customer?, Map<String, dynamic>, Function(int)> customerHandler;
  late DataHandler<dynamic, List, Function(int)> nearbyCustomersHandler;
  late DataHandler<dynamic, List, Function(int)> bpCustomersHandler;
  late DataHandler<dynamic, String, Function(FormData)> createHandler;

  List<BpCustomer> get customers => customersHandler.value;
  Customer? get customer => customerHandler.value;
  MapsLoc? get mapsLoc => locationHandler.value;
  Map<int, String> get types => typesHandler.value;
  Map<int, String> get statuses => statusesHandler.value;

  List<BpCustomer> _customersFromList(List data, LatLng currentPos) {
    List<BpCustomer> customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    return customers.where((element) {
      LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
      double radius = calculateDistance(coords1, coords2);
      element.radius = radius;
      return radius <= 100;
    }).toList();
  }

  Map<int, String> typesFromList(List data) {
    Map<int, String> typesData = {};
    List<DBType> types = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    for (var type in types) {
      typesData[type.typeid ?? 0] = type.typename ?? '';
    }
    return typesData;
  }

  Map<int, String> statusesFromList(List data) {
    Map<int, String> statusesData = {};
    List<DBType> statuses = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    for (var type in statuses) {
      statusesData[type.typeid ?? 0] = type.typename ?? '';
    }
    return statusesData;
  }

  String? getCountryName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      return addresses.firstWhere((element) => element.types!.contains('country')).longName ?? "";
    }
    return null;
  }

  String? getProvinceName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      return addresses.firstWhere((element) => element.types!.contains('administrative_area_level_1')).longName ?? "";
    }
    return null;
  }

  String? getCityName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      String city = addresses.firstWhere((element) => element.types!.contains('administrative_area_level_2')).longName ?? "";
      // replace word Kota, Kab, or Kabupaten with Empty String
      return city.replaceAll(RegExp(r'Kota |Kabupaten |Kab '), '');
    }
    return null;
  }

  String? getSubdistrictName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      String subdistrict = addresses.firstWhere((element) => element.types!.contains('administrative_area_level_3')).longName ?? "";

      return subdistrict.replaceAll(RegExp(r'Kecamatan |Kec '), '');
    }
    return null;
  }

  String? getPostalCodeName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      return addresses.firstWhere((element) => element.types!.contains('postal_code')).longName ?? "";
    }
    return null;
  }

  String? getAddress() {
    return mapsLoc?.adresses?.first.formattedAddress;
  }

  void checkCustomers(List<Customer> nearbyCustomers) {
    LatLng currentPos = LatLng(property.latitude!, property.longitude!);
    nearbyCustomers = nearbyCustomers.where((element) {
      LatLng coords1 = LatLng(element.cstmlatitude ?? 0.0, element.cstmlongitude ?? 0.0);
      double radius = calculateDistance(coords1, currentPos);
      element.radius = radius;
      return radius <= 100 && (element.cstmname?.toLowerCase() == formSource.cstmname.toLowerCase() || element.cstmaddress?.toLowerCase() == formSource.cstmaddress?.toLowerCase());
    }).toList();

    if (nearbyCustomers.isNotEmpty) {
      Customer customer = nearbyCustomers.first;
      Get.find<TaskHelper>().confirmPush(
        Task(
          nearbyCustomersID,
          message: "${customer.cstmname} already exists. Your customer will add to existing customer",
          onFinished: (res) {
            if (res) {
              bpCustomersHandler.fetcher.run(customer.cstmid!);
            }
          },
        ),
      );
    } else {
      Get.find<TaskHelper>().confirmPush(
        Task(
          nearbyCustomersID,
          message: "There is no customer with given name or address in your area, this customer will create as new customer",
          onFinished: (res) {
            if (res) {
              formSource.onSubmit();
            }
          },
        ),
      );
    }
  }

  Future<List<Country>> fetchCountries([String? search]) async => await presenter.fetchCountries(search);
  Future<List<Province>> fetchProvinces(int countryId, [String? search]) async => await presenter.fetchProvinces(countryId, search);
  Future<List<City>> fetchCities(int provinceId, [String? search]) async => await presenter.fetchCities(provinceId, search);
  Future<List<Subdistrict>> fetchSubdistricts(int cityId, [String? search]) async => await presenter.fetchSubdistricts(cityId, search);

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  List<BpCustomer> _customersSuccess(List data) {
    List<BpCustomer> customers = _customersFromList(
      data,
      LatLng(property.markers.first.position.latitude, property.markers.first.position.longitude),
    );
    property.deployCustomers(customers);
    return customers;
  }

  MapsLoc _locationSuccess(Map<String, dynamic> data) {
    MapsLoc mapsLoc = MapsLoc.fromJson(data);
    return mapsLoc;
  }

  void _placesSuccess(Map<String, dynamic> data) {
    if (data['province'] != null && data['city'] != null && data['subdistrict'] != null) {
      formSource.provinceid = Province.fromJson(data['province']).provid;
      formSource.cityid = City.fromJson(data['city']).cityid;
      formSource.subdistrictid = Subdistrict.fromJson(data['subdistrict']).subdistrictid;

      if (customer != null) {
        customer!.cstmcountry = Province.fromJson(data['province']).provcountry;
      }
    } else {
      throw "The selected location is not available";
    }
  }

  Customer _customerSuccess(Map<String, dynamic> data) {
    Customer customer = Customer.fromJson(data);
    formSource.prepareFormValues();
    return customer;
  }

  void _customerComplete() {
    if (customer?.cstmsubdistrict != null) {
      placesHandler.fetcher.run(customer!.cstmsubdistrict!.subdistrictname!);
    }
  }

  void _nearbyCustomersSuccess(List data) {
    List<Customer> nearbyCustomers = List<Customer>.from(data.map((e) => Customer.fromJson(e)));
    checkCustomers(nearbyCustomers);
  }

  void _bpCustomersSuccess(List data) {
    List<BpCustomer> bpCustomers = List<BpCustomer>.from(data.map((e) => BpCustomer.fromJson(e)));
    if (bpCustomers.isEmpty) {
      formSource.onSubmit();
    } else {
      Get.find<TaskHelper>().failedPush(
        Task(
          bpCustomersID,
          message: "Customer already exist in your business partner",
        ),
      );
    }
  }

  void _createSuccess(String data) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: data,
        onFinished: (res) {
          Get.find<NearbyStateController>().refreshStates();
          Get.back(id: NearbyNavigator.id);
        },
      ),
    );
  }

  DataHandler<D, R, F> createDataHandler<D, R, F extends Function>(String id, DataFetcher<F, R> fetcher, D initialValue, D Function(R) onSuccess, {Function()? onComplete}) {
    return DataHandler<D, R, F>(
      id,
      initialValue: initialValue,
      fetcher: fetcher,
      onFailed: (message) => _showFailed(id, message),
      onError: (message) => _showError(id, message),
      onSuccess: onSuccess,
      onComplete: onComplete,
    );
  }

  @override
  void init() {
    super.init();

    userHandler = createDataHandler(userID, presenter.fetchUser, null, (data) => formSource.sbcbpid = UserDetail.fromJson(data).userdtbpid);
    customersHandler = createDataHandler(customersID, presenter.fetchCustomers, [], _customersSuccess);
    statusesHandler = createDataHandler(statusesID, presenter.fetchStatuses, {}, (data) => statusesFromList(data));
    typesHandler = createDataHandler(typesID, presenter.fetchTypes, {}, (data) => typesFromList(data));
    locationHandler = createDataHandler(locationID, presenter.fetchLocation, null, _locationSuccess, onComplete: () => placesHandler.fetcher.run(getSubdistrictName()!));
    placesHandler = createDataHandler(placesID, presenter.fetchPlaces, null, _placesSuccess);
    customerHandler = createDataHandler(customerID, presenter.fetchCustomer, null, _customerSuccess, onComplete: _customerComplete);

    nearbyCustomersHandler = DataHandler(
      nearbyCustomersID,
      initialValue: null,
      fetcher: presenter.fetchNearbyCustomers,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(nearbyCustomersID)),
      onFailed: (message) => _showFailed(nearbyCustomersID, message, false),
      onError: (message) => _showError(nearbyCustomersID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(nearbyCustomersID),
      onSuccess: _nearbyCustomersSuccess,
    );

    bpCustomersHandler = DataHandler(
      bpCustomersID,
      initialValue: null,
      fetcher: presenter.fetchBpCustomers,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(bpCustomersID)),
      onFailed: (message) => _showFailed(bpCustomersID, message, false),
      onError: (message) => _showError(bpCustomersID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(bpCustomersID),
      onSuccess: _bpCustomersSuccess,
    );

    createHandler = DataHandler(
      createID,
      initialValue: null,
      fetcher: presenter.create,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onFailed: (message) => _showFailed(createID, message, false),
      onError: (message) => _showError(createID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
      onSuccess: _createSuccess,
    );
  }

  @override
  CustomerFormCreatePresenter presenterBuilder() => CustomerFormCreatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onCreateError(String message) {}

  @override
  void onCreateFailed(String message) {}

  @override
  void onCreateSuccess(String message) {}

  @override
  void onCreateComplete() {}

  @override
  onLoadComplete() {}
}
