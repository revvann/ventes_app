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
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';

class CustomerFormCreateDataSource extends StateDataSource<CustomerFormCreatePresenter> implements CustomerCreateContract {
  Listener get _listener => Get.find<Listener>(tag: NearbyString.customerCreateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: NearbyString.customerCreateTag);
  Property get _property => Get.find<Property>(tag: NearbyString.customerCreateTag);

  final _customers = <BpCustomer>[].obs;
  set customers(List<BpCustomer> value) => _customers.value = value;
  List<BpCustomer> get customers => _customers.value;

  final _customer = Rx<Customer?>(null);
  set customer(Customer? value) => _customer.value = value;
  Customer? get customer => _customer.value;

  final _mapsLoc = Rx<MapsLoc?>(null);
  set mapsLoc(MapsLoc? value) => _mapsLoc.value = value;
  MapsLoc? get mapsLoc => _mapsLoc.value;

  final _types = <int, String>{}.obs;
  set types(Map<int, String> value) => _types.value = value;
  Map<int, String> get types => _types.value;

  final _statuses = <int, String>{}.obs;
  set statuses(Map<int, String> value) => _statuses.value = value;
  Map<int, String> get statuses => _statuses.value;

  void customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers.where((element) {
      LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
      double radius = calculateDistance(coords1, coords2);
      element.radius = radius;
      return radius <= 100;
    }).toList();
  }

  void typesFromList(List data) {
    Map<int, String> typesData = {};
    List<DBType> types = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    for (var type in types) {
      typesData[type.typeid ?? 0] = type.typename ?? '';
    }
    this.types = typesData;
  }

  void statusesFromList(List data) {
    Map<int, String> statusesData = {};
    List<DBType> statuses = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    for (var type in statuses) {
      statusesData[type.typeid ?? 0] = type.typename ?? '';
    }
    this.statuses = statusesData;
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

  Future<List<Country>> fetchCountries([String? search]) async => await presenter.fetchCountries(search);
  Future<List<Province>> fetchProvinces(int countryId, [String? search]) async => await presenter.fetchProvinces(countryId, search);
  Future<List<City>> fetchCities(int provinceId, [String? search]) async => await presenter.fetchCities(provinceId, search);
  Future<List<Subdistrict>> fetchSubdistricts(int cityId, [String? search]) async => await presenter.fetchSubdistricts(cityId, search);

  void fetchData(double latitude, double longitude, int? cstmid) => presenter.fetchData(latitude, longitude, cstmid);
  void fetchPlacesIds(String subdistrict) => presenter.fetchPlaces(subdistrict);
  void createCustomer(FormData data) => presenter.createCustomer(data);

  @override
  CustomerFormCreatePresenter presenterBuilder() => CustomerFormCreatePresenter();

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['customers'] != null) {
      customersFromList(
        data['customers'],
        LatLng(_property.markers.first.position.latitude, _property.markers.first.position.longitude),
      );
      _property.deployCustomers(customers);
    }

    if (data['types'] != null) {
      typesFromList(data['types']);
    }

    if (data['statuses'] != null) {
      statusesFromList(data['statuses']);
    }

    if (data['user'] != null) {
      _formSource.sbcbpid = UserDetail.fromJson(data['user']).userdtbpid;
    }

    if (data['location'] != null) {
      mapsLoc = MapsLoc.fromJson(data['location']);
      _property.fetchPlacesIds();
    }

    if (data['places'] != null) {
      Map places = data['places'];
      if (places['province'] != null && places['city'] != null && places['subdistrict'] != null) {
        _formSource.provinceid = Province.fromJson(places['province']).provid;
        _formSource.cityid = City.fromJson(places['city']).cityid;
        _formSource.subdistrictid = Subdistrict.fromJson(places['subdistrict']).subdistrictid;
      } else {
        throw "The selected location is not available";
      }
    }

    if (data['customer'] != null) {
      customer = Customer.fromJson(data['customer']);
      _formSource.prepareFormValues();
    }

    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  void onCreateError(String message) => _listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => _listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => _listener.onCreateDataSuccess(message);
}
