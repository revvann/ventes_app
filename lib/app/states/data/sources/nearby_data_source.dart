import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/nearby_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class NearbyDataSource extends StateDataSource<NearbyPresenter> with DataSourceMixin implements NearbyContract {
  final String locationID = 'lochdr';
  final String bpCustomersID = 'bpcusthdr';
  final String customersID = 'custhdr';
  final String deleteID = 'delhdr';

  late DataHandler<Map<String, dynamic>, Future Function(double, double)> locationHandler;
  late DataHandler<List, Function()> bpCustomersHandler;
  late DataHandler<List, Future Function(String)> customersHandler;
  late DataHandler<String, Function(int)> deleteHandler;

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

  String get subdistrictName =>
      mapsLoc.adresses!.first.addressComponents!.firstWhere((element) => element.types!.contains('administrative_area_level_3')).longName!.replaceAll(RegExp(r'Kecamatan |Kec '), '');

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  void _deleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().refreshStates();
        }));
  }

  void _customersSuccess(List data) {
    _customersFromList(
      data,
      LatLng(property.markers.first.position.latitude, property.markers.first.position.longitude),
    );
    property.deployCustomers(customers);
  }

  void _locationSuccess(Map<String, dynamic> data) {
    _locationDetailLoaded(data);
    customersHandler.fetcher.run(subdistrictName);
  }

  @override
  void init() {
    super.init();

    customersHandler = DataHandler(
      customersID,
      fetcher: presenter.fetchCustomers,
      onFailed: (message) => _showFailed(customersID, message),
      onError: (message) => _showError(customersID, message),
      onSuccess: _customersSuccess,
    );

    locationHandler = DataHandler(
      locationID,
      fetcher: presenter.fetchLocation,
      onFailed: (message) => _showFailed(locationID, message),
      onError: (message) => _showError(locationID, message),
      onSuccess: _locationSuccess,
    );

    bpCustomersHandler = DataHandler(
      bpCustomersID,
      fetcher: presenter.fetchBpCustomers,
      onFailed: (message) => _showFailed(bpCustomersID, message),
      onError: (message) => _showError(bpCustomersID, message),
      onSuccess: (data) => bpCustomers = List<BpCustomer>.from(data.map((e) => BpCustomer.fromJson(e))),
    );

    deleteHandler = DataHandler(
      deleteID,
      fetcher: presenter.delete,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteID)),
      onError: (message) => _showError(deleteID, message),
      onFailed: (message) => _showFailed(deleteID, message, false),
      onSuccess: (data) => _deleteSuccess("Logout Success"),
      onComplete: () => Get.find<TaskHelper>().loaderPop(deleteID),
    );
  }

  @override
  NearbyPresenter presenterBuilder() => NearbyPresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onDeleteError(String message) {}

  @override
  void onDeleteFailed(String message) {}

  @override
  void onDeleteSuccess(String message) {}

  @override
  void onDeleteComplete() {}

  @override
  onLoadComplete() {}
}