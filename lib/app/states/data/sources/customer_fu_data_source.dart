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
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';

class CustomerFormUpdateDataSource extends StateDataSource<CustomerFormUpdatePresenter> with DataSourceMixin implements CustomerUpdateContract {
  final String bpCustomersID = 'bpcusthdr';
  final String customersID = 'custhdr';
  final String typesID = 'tpshdr';
  final String statusesID = 'stsshdr';
  final String bpCustomerID = 'bpcsthdr';
  final String updateID = 'updthdr';

  late DataHandler<List<BpCustomer>, List, Function()> bpCustomersHandler;
  late DataHandler<List<Customer>, List, Function()> customersHandler;
  late DataHandler<Map<int, String>, List, Function()> typesHandler;
  late DataHandler<Map<int, String>, List, Function()> statusesHandler;
  late DataHandler<BpCustomer?, Map<String, dynamic>, Function(int)> bpCustomerHandler;
  late DataHandler<dynamic, String, Function(int, FormData)> updateHandler;

  List<Customer> get customers => customersHandler.value;
  List<BpCustomer> get bpCustomers => bpCustomersHandler.value;
  BpCustomer? get bpCustomer => bpCustomerHandler.value;
  Map<int, String> get types => typesHandler.value;
  Map<int, String> get statuses => statusesHandler.value;

  bool bpCustomersHas(Customer customer) {
    return bpCustomers.any((element) => element.sbccstmid == customer.cstmid);
  }

  List<Customer> customersFromList(List data, LatLng currentPos) {
    List<Customer> customers = data.map((e) => Customer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    return customers.where((element) {
      LatLng coords1 = LatLng(element.cstmlatitude ?? 0.0, element.cstmlongitude ?? 0.0);
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
    for (var statuse in statuses) {
      statusesData[statuse.typeid ?? 0] = statuse.typename ?? '';
    }
    return statusesData;
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

  List<Customer> _customersSuccess(List data) {
    List<Customer> customers = customersFromList(
      data,
      LatLng(property.markers.first.position.latitude, property.markers.first.position.longitude),
    );
    property.deployCustomers(customers);
    return customers;
  }

  BpCustomer _bpCustomerSuccess(Map<String, dynamic> data) {
    BpCustomer bpCustomer = BpCustomer.fromJson(data);
    return bpCustomer;
  }

  void _bpCustomerComplete() {
    property.moveCamera().then((res) {
      formSource.prepareFormValues();
      customersHandler.fetcher.run();
    });
  }

  List<BpCustomer> _bpCustomersSucccess(data) {
    List<BpCustomer> bpCustomers = List<BpCustomer>.from(data.map((e) => BpCustomer.fromJson(e)));
    property.deployCustomers(customers);
    return bpCustomers;
  }

  @override
  void init() {
    super.init();

    bpCustomersHandler = createDataHandler(bpCustomersID, presenter.fetchBpCustomers, [], _bpCustomersSucccess);
    customersHandler = createDataHandler(customersID, presenter.fetchCustomers, [], _customersSuccess);
    typesHandler = createDataHandler(typesID, presenter.fetchTypes, {}, (data) => typesFromList(data));
    statusesHandler = createDataHandler(statusesID, presenter.fetchStatuses, {}, (data) => statusesFromList(data));

    bpCustomerHandler = DataHandler(
      bpCustomerID,
      initialValue: null,
      fetcher: presenter.fetchBpCustomer,
      onFailed: (message) => _showFailed(bpCustomerID, message),
      onError: (message) => _showError(bpCustomerID, message),
      onSuccess: _bpCustomerSuccess,
      onComplete: _bpCustomerComplete,
    );

    updateHandler = DataHandler(
      updateID,
      initialValue: null,
      fetcher: presenter.update,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(updateID)),
      onFailed: (message) => _showFailed(bpCustomerID, message, false),
      onError: (message) => _showError(bpCustomerID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(updateID),
      onSuccess: (data) => Get.find<TaskHelper>().successPush(
        Task(
          updateID,
          message: data,
          onFinished: (res) {
            Get.find<NearbyStateController>().refreshStates();
            Get.back(id: NearbyNavigator.id);
          },
        ),
      ),
    );
  }

  @override
  CustomerFormUpdatePresenter presenterBuilder() => CustomerFormUpdatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onUpdateError(String message) {}

  @override
  void onUpdateFailed(String message) {}

  @override
  void onUpdateSuccess(String message) {}

  @override
  onLoadComplete() {}

  @override
  void onUpdateComplete() {}
}
