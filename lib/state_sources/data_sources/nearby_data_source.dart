import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/network/presenters/nearby_presenter.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';

class NearbyDataSource {
  final NearbyPresenter _presenter = NearbyPresenter();
  set fetchDataContract(FetchDataContract value) => _presenter.fetchDataContract = value;

  final Rx<MapsLoc> _mapsLoc = Rx<MapsLoc>(MapsLoc());
  set mapsLoc(MapsLoc value) => _mapsLoc.value = value;
  MapsLoc get mapsLoc => _mapsLoc.value;

  void getDetail(LatLng position) => _presenter.getDetail(position.latitude, position.longitude);
  void detailLoaded(Map<String, dynamic> data) {
    mapsLoc = MapsLoc.fromJson(data);
  }
}
