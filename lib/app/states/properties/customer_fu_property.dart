// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';

class CustomerFormUpdateProperty extends StateProperty {
  CustomerFormUpdateFormSource get _formSource => Get.find<CustomerFormUpdateFormSource>(tag: NearbyString.customerUpdateTag);
  CustomerFormUpdateDataSource get _dataSource => Get.find<CustomerFormUpdateDataSource>(tag: NearbyString.customerUpdateTag);

  Task task = Task(NearbyString.updateTaskCode);

  final double defaultZoom = 20;
  final Completer<GoogleMapController> mapsController = Completer();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  CameraMoveType cameraMoveType = CameraMoveType.controller;
  int? customerid;

  final Rx<double> mapsHeight = Rx<double>(0);
  final Rx<double> bottomSheetHeight = Rx<double>(0);

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});
  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;
  set markerLatLng(LatLng latlng) {
    Marker marker = Marker(
      markerId: MarkerId(NearbyString.selectedLocId),
      infoWindow: InfoWindow(title: _formSource.cstmname),
      position: latlng,
    );

    if (markers.isNotEmpty) {
      List<Marker> markersList = markers.toList();
      markersList[0] = marker;
      markers = Set.from(markersList);
    } else {
      markers = {marker};
    }
  }

  void deployCustomers(List<Customer> data) async {
    List<Marker> markersList = [markers.first];
    for (var element in data) {
      bool isInBp = _dataSource.bpCustomersHas(element);
      Marker marker = Marker(
        markerId: MarkerId((element.cstmid ?? "0").toString()),
        infoWindow: InfoWindow(title: element.cstmname ?? "Unknown"),
        position: LatLng(element.cstmlatitude!, element.cstmlongitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(isInBp ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueCyan),
      );
      markersList.add(marker);
    }
    markers = Set.from(markersList);
  }

  Future moveCamera() async {
    if (_dataSource.bpCustomer != null) {
      LatLng pos = LatLng(_dataSource.bpCustomer!.sbccstm!.cstmlatitude!, _dataSource.bpCustomer!.sbccstm!.cstmlongitude!);
      GoogleMapController controller = await mapsController.future;
      await controller.animateCamera(
        CameraUpdate.newLatLng(pos),
      );
      markerLatLng = pos;
    }
  }

  void refresh() {
    _dataSource.fetchData(customerid ?? 0);
    Get.find<TaskHelper>().loaderPush(task);
  }

  @override
  void ready() {
    super.ready();
    double bottomSheetHeight = bottomSheetKey.currentContext?.size?.height ?? 0;
    double stackHeight = stackKey.currentContext?.size?.height ?? 0;
    this.bottomSheetHeight.value = stackHeight - RegularSize.l;
    mapsHeight.value = (stackHeight - bottomSheetHeight) + 10;
  }
}
