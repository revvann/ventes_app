import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/nearby_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';

class NearbyDataSource extends StateDataSource<NearbyPresenter> with DataSourceMixin implements NearbyContract {
  List<BpCustomer> bpCustomers = <BpCustomer>[];

  final _customers = Rx<List<Customer>>([]);
  set customers(List<Customer> value) => _customers.value = value;
  List<Customer> get customers => _customers.value;

  final Rx<MapsLoc> _mapsLoc = Rx<MapsLoc>(MapsLoc());
  set mapsLoc(MapsLoc value) => _mapsLoc.value = value;
  MapsLoc get mapsLoc => _mapsLoc.value;

  bool bpCustomersHas(Customer customer) {
    return bpCustomers.any((element) => element.sbccstmid == customer.cstmid);
  }

  Future<String?> fetchAddress(double latitude, double longitude) async {
    MapsLoc? mapsLoc = await fetchDetailLoc(latitude, longitude);
    return mapsLoc?.adresses?.isNotEmpty ?? false ? mapsLoc?.adresses?.first.formattedAddress : "";
  }

  Future<MapsLoc?> fetchDetailLoc(double latitude, double longitude) => presenter.fetchLocationDetail(latitude, longitude);
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
  onLoadError(String message) => listener.onLoadDataError(message);

  @override
  onLoadFailed(String message) => listener.onLoadDataFailed(message);

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
        LatLng(property.markers.first.position.latitude, property.markers.first.position.longitude),
      );
      property.deployCustomers(customers);
    }
  }

  @override
  void onDeleteError(String message) => listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => listener.onDeleteSuccess(message);

  @override
  void onDeleteComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
