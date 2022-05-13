import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/network/presenters/nearby_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/helpers/function_helpers.dart';

class NearbyDataSource {
  final NearbyPresenter _presenter = NearbyPresenter();
  set fetchDataContract(FetchDataContract value) => _presenter.fetchDataContract = value;

  final _customers = <BpCustomer>[].obs;
  set customers(List<BpCustomer> value) => _customers.value = value;
  List<BpCustomer> get customers => _customers.value;

  final Rx<MapsLoc> _mapsLoc = Rx<MapsLoc>(MapsLoc());
  set mapsLoc(MapsLoc value) => _mapsLoc.value = value;
  MapsLoc get mapsLoc => _mapsLoc.value;

  void fetchData(LatLng position) => _presenter.fetchData(position.latitude, position.longitude);
  void locationDetailLoaded(Map<String, dynamic> data) {
    mapsLoc = MapsLoc.fromJson(data);
  }

  void customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers
        .map((element) {
          LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
          double radius = calculateDistance(coords1, coords2);
          element.radius = radius;
          return element;
        })
        .where((element) => element.radius != null ? element.radius! <= 100 : false)
        .toList();
  }
}
