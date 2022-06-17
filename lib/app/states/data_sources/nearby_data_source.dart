part of 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class NearbyDataSource extends StateDataSource<NearbyPresenter> implements NearbyContract {
  NearbyProperty get _properties => Get.find<NearbyProperty>(tag: NearbyString.nearbyTag);
  NearbyListener get _listener => Get.find<NearbyListener>(tag: NearbyString.nearbyTag);
  List<BpCustomer> bpCustomers = <BpCustomer>[];

  final _customers = <Customer>[].obs;
  set customers(List<Customer> value) => _customers.value = value;
  List<Customer> get customers => _customers.value;

  final Rx<MapsLoc> _mapsLoc = Rx<MapsLoc>(MapsLoc());
  set mapsLoc(MapsLoc value) => _mapsLoc.value = value;
  MapsLoc get mapsLoc => _mapsLoc.value;

  bool bpCustomersHas(Customer customer) {
    return bpCustomers.any((element) => element.sbccstmid == customer.cstmid);
  }

  void deleteData(int id) => presenter.deleteData(id);
  void fetchData(LatLng position) => presenter.fetchData(position.latitude, position.longitude);
  void _locationDetailLoaded(Map<String, dynamic> data) {
    mapsLoc = MapsLoc.fromJson(data);
  }

  void bpCustomersLoaded(List<dynamic> data) {
    bpCustomers = data.map((e) => BpCustomer.fromJson(e)).toList();
  }

  void _customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => Customer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers.map((element) => _mappingBpCustomer(element, coords2)).where(_isCustomerInRange).toList();
  }

  Customer _mappingBpCustomer(Customer element, LatLng currentCoordinates) {
    LatLng coords1 = LatLng(element.cstmlatitude ?? 0.0, element.cstmlongitude ?? 0.0);
    double radius = calculateDistance(coords1, currentCoordinates);
    element.radius = radius;
    return element;
  }

  bool _isCustomerInRange(element) => element.radius != null ? element.radius! <= 100 : false;

  @override
  NearbyPresenter presenterBuilder() => NearbyPresenter();

  @override
  onLoadError(String message) => _listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['location'] != null) {
      _locationDetailLoaded(data['location'] as Map<String, dynamic>);
    }

    if (data['bpcustomers'] != null) {
      bpCustomers = List<BpCustomer>.from(data['bpcustomers'].map((e) => BpCustomer.fromJson(e)));
    }

    if (data['customers'] != null) {
      _customersFromList(
        data['customers'],
        LatLng(_properties.markers.first.position.latitude, _properties.markers.first.position.longitude),
      );
      _properties.deployCustomers(customers);
    }
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  void onDeleteError(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => _listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => _listener.onDeleteSuccess(message);
}
