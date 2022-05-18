import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/network/presenters/nearby_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/listeners/nearby_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';

class NearbyDataSource implements FetchDataContract {
  NearbyProperties get _properties => Get.find<NearbyProperties>();
  NearbyListener get _listener => Get.find<NearbyListener>();

  final NearbyPresenter _presenter = NearbyPresenter();

  List<BpCustomer> bpCustomers = <BpCustomer>[];

  final _customers = <Customer>[].obs;
  set customers(List<Customer> value) => _customers.value = value;
  List<Customer> get customers => _customers.value;

  final Rx<MapsLoc> _mapsLoc = Rx<MapsLoc>(MapsLoc());
  set mapsLoc(MapsLoc value) => _mapsLoc.value = value;
  MapsLoc get mapsLoc => _mapsLoc.value;

  void init() {
    _presenter.fetchDataContract = this;
  }

  bool bpCustomersHas(Customer customer) {
    return bpCustomers.any((element) => element.sbccstmid == customer.cstmid);
  }

  void fetchData(LatLng position) => _presenter.fetchData(position.latitude, position.longitude);
  void locationDetailLoaded(Map<String, dynamic> data) {
    mapsLoc = MapsLoc.fromJson(data);
  }

  void bpCustomersLoaded(List<dynamic> data) {
    bpCustomers = data.map((e) => BpCustomer.fromJson(e)).toList();
  }

  void customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => Customer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers
        .map((element) {
          LatLng coords1 = LatLng(element.cstmlatitude ?? 0.0, element.cstmlongitude ?? 0.0);
          double radius = calculateDistance(coords1, coords2);
          element.radius = radius;
          return element;
        })
        .where((element) => element.radius != null ? element.radius! <= 100 : false)
        .toList();
  }

  @override
  onLoadError(String message) => _listener.onLoadDataError();

  @override
  onLoadFailed(String message) => _listener.onLoadDataFailed();

  @override
  onLoadSuccess(Map data) {
    if (data['location'] != null) {
      locationDetailLoaded(data['location'] as Map<String, dynamic>);
    }

    if (data['bpcustomers'] != null) {
      bpCustomers = data['bpcustomers'].map((e) => BpCustomer.fromJson(e)).toList();
    }

    if (data['customers'] != null) {
      customersFromList(
        data['customers'],
        LatLng(_properties.markers.first.position.latitude, _properties.markers.first.position.longitude),
      );
      _properties.deployCustomers(customers);
    }
    Get.close(1);
  }
}
