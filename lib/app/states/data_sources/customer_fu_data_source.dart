import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/customer_fu_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class CustomerFormUpdateDataSource extends StateDataSource<CustomerFormUpdatePresenter> with DataSourceMixin implements CustomerUpdateContract {
  final _customers = Rx<List<Customer>>([]);
  set customers(List<Customer> value) => _customers.value = value;
  List<Customer> get customers => _customers.value;

  final _bpCustomers = Rx<List<BpCustomer>>([]);
  set bpCustomers(List<BpCustomer> value) => _bpCustomers.value = value;
  List<BpCustomer> get bpCustomers => _bpCustomers.value;

  final _bpCustomer = Rx<BpCustomer?>(null);
  set bpCustomer(BpCustomer? value) => _bpCustomer.value = value;
  BpCustomer? get bpCustomer => _bpCustomer.value;

  final _types = Rx<Map<int, String>>({});
  set types(Map<int, String> value) => _types.value = value;
  Map<int, String> get types => _types.value;

  final _statuses = Rx<Map<int, String>>({});
  set statuses(Map<int, String> value) => _statuses.value = value;
  Map<int, String> get statuses => _statuses.value;

  bool bpCustomersHas(Customer customer) {
    return bpCustomers.any((element) => element.sbccstmid == customer.cstmid);
  }

  void customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => Customer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers.where((element) {
      LatLng coords1 = LatLng(element.cstmlatitude ?? 0.0, element.cstmlongitude ?? 0.0);
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
    for (var statuse in statuses) {
      statusesData[statuse.typeid ?? 0] = statuse.typename ?? '';
    }
    this.statuses = statusesData;
  }

  Future<List<Country>> fetchCountries([String? search]) async => await presenter.fetchCountries(search);
  Future<List<Province>> fetchProvinces(int countryId, [String? search]) async => await presenter.fetchProvinces(countryId, search);
  Future<List<City>> fetchCities(int provinceId, [String? search]) async => await presenter.fetchCities(provinceId, search);
  Future<List<Subdistrict>> fetchSubdistricts(int cityId, [String? search]) async => await presenter.fetchSubdistricts(cityId, search);

  void fetchData(int id) => presenter.fetchData(id);
  void updateCustomer(int id, FormData data) => presenter.updateCustomer(id, data);

  @override
  CustomerFormUpdatePresenter presenterBuilder() => CustomerFormUpdatePresenter();

  @override
  onLoadError(String message) => listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) async {
    if (data['bpcustomer'] != null) {
      bpCustomer = BpCustomer.fromJson(data['bpcustomer']);
      await property.moveCamera();
      formSource.prepareFormValues();
    }

    if (data['customers'] != null) {
      customersFromList(
        data['customers'],
        LatLng(property.markers.first.position.latitude, property.markers.first.position.longitude),
      );
      property.deployCustomers(customers);
    }

    if (data['bpcustomers'] != null) {
      bpCustomers = List<BpCustomer>.from(data['bpcustomers'].map((e) => BpCustomer.fromJson(e)));
    }

    if (data['types'] != null) {
      typesFromList(data['types']);
    }

    if (data['statuses'] != null) {
      statusesFromList(data['statuses']);
    }

    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  void onUpdateError(String message) => listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => listener.onUpdateDataSuccess(message);

  @override
  onLoadComplete() => listener.onComplete();

  @override
  void onUpdateComplete() => listener.onComplete();
}
