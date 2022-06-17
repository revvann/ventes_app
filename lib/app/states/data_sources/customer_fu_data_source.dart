part of 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';

class CustomerFormUpdateDataSource extends StateDataSource<CustomerFormUpdatePresenter> implements CustomerUpdateContract {
  CustomerFormUpdateListener get _listener => Get.find<CustomerFormUpdateListener>(tag: NearbyString.customerUpdateTag);
  CustomerFormUpdateFormSource get _formSource => Get.find<CustomerFormUpdateFormSource>(tag: NearbyString.customerUpdateTag);
  CustomerFormUpdateProperty get _properties => Get.find<CustomerFormUpdateProperty>(tag: NearbyString.customerUpdateTag);

  final _customers = <Customer>[].obs;
  set customers(List<Customer> value) => _customers.value = value;
  List<Customer> get customers => _customers.value;

  final _bpCustomers = <BpCustomer>[].obs;
  set bpCustomers(List<BpCustomer> value) => _bpCustomers.value = value;
  List<BpCustomer> get bpCustomers => _bpCustomers.value;

  final _bpCustomer = Rx<BpCustomer?>(null);
  set bpCustomer(BpCustomer? value) => _bpCustomer.value = value;
  BpCustomer? get bpCustomer => _bpCustomer.value;

  final _types = <int, String>{}.obs;
  set types(Map<int, String> value) => _types.value = value;
  Map<int, String> get types => _types.value;

  final _statuses = <int, String>{}.obs;
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
  onLoadError(String message) => _listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) async {
    if (data['bpcustomer'] != null) {
      bpCustomer = BpCustomer.fromJson(data['bpcustomer']);
      await _properties.moveCamera();
      _formSource.prepareFormValues();
    }

    if (data['customers'] != null) {
      customersFromList(
        data['customers'],
        LatLng(_properties.markers.first.position.latitude, _properties.markers.first.position.longitude),
      );
      _properties.deployCustomers(customers);
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

    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
