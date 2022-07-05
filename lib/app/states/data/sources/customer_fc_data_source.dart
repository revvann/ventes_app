import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/city_model.dart';
import 'package:ventes/app/api/models/customer_model.dart';
import 'package:ventes/app/api/models/maps_loc.dart';
import 'package:ventes/app/api/models/province_model.dart';
import 'package:ventes/app/api/models/subdistrict_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/api/models/village_model.dart';
import 'package:ventes/app/api/presenters/customer_fc_presenter.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

class CustomerFormCreateDataSource extends StateDataSource<CustomerFormCreatePresenter> with DataSourceMixin {
  final String userID = "usrhdr";
  final String customersID = 'custshdr';
  final String statusesID = 'stsshdr';
  final String typesID = 'typshdr';
  final String locationID = 'locationhdr';
  final String placesID = 'placeshdr';
  final String customerID = 'custohdr';
  final String nearbyCustomersID = 'nearcusthdr';
  final String bpCustomersID = 'bpcustomerid';
  final String createID = 'create';

  late DataHandler<dynamic, Map<String, dynamic>, Function()> userHandler;
  late DataHandler<List<BpCustomer>, List, Function()> customersHandler;
  late DataHandler<Map<int, String>, List, Function()> statusesHandler;
  late DataHandler<Map<int, String>, List, Function()> typesHandler;
  late DataHandler<MapsLoc?, Map<String, dynamic>, Function(double, double)> locationHandler;
  late DataHandler<dynamic, Map<String, dynamic>, Function(String, String, String, String)> placesHandler;
  late DataHandler<Customer?, Map<String, dynamic>, Function(int)> customerHandler;
  late DataHandler<dynamic, List, Function(int)> nearbyCustomersHandler;
  late DataHandler<dynamic, List, Function(int)> bpCustomersHandler;
  late DataHandler<dynamic, String, Function(FormData)> createHandler;

  List<BpCustomer> get customers => customersHandler.value;
  Customer? get customer => customerHandler.value;
  MapsLoc? get mapsLoc => locationHandler.value;
  Map<int, String> get types => typesHandler.value;
  Map<int, String> get statuses => statusesHandler.value;

  List<BpCustomer> _customersFromList(List data, LatLng currentPos) {
    List<BpCustomer> customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    return customers.where((element) {
      LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
      double radius = Utils.calculateDistance(coords1, coords2);
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
    for (var type in statuses) {
      statusesData[type.typeid ?? 0] = type.typename ?? '';
    }
    return statusesData;
  }

  String? getCountryName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      return addresses.firstWhere((element) => element.types!.contains('country')).longName ?? "";
    }
    return null;
  }

  String? getProvinceName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      return addresses.firstWhere((element) => element.types!.contains('administrative_area_level_1')).longName ?? "";
    }
    return null;
  }

  String? getCityName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      String city = addresses.firstWhere((element) => element.types!.contains('administrative_area_level_2')).longName ?? "";
      // replace word Kota, Kab, or Kabupaten with Empty String
      return city.replaceAll(RegExp(r'Kota |Kabupaten |Kab '), '');
    }
    return null;
  }

  String? getSubdistrictName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      String subdistrict = addresses.firstWhere((element) => element.types!.contains('administrative_area_level_3')).longName ?? "";

      return subdistrict.replaceAll(RegExp(r'Kecamatan |Kec '), '');
    }
    return null;
  }

  String? getVillageName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      String subdistrict = addresses.firstWhere((element) => element.types!.contains('administrative_area_level_4')).longName ?? "";

      return subdistrict.replaceAll(RegExp(r'Desa |Kelurahan |Kel '), '');
    }
    return null;
  }

  String? getPostalCodeName() {
    List<AddressComponents>? addresses = mapsLoc?.adresses?.first.addressComponents;
    if (addresses != null) {
      return addresses.firstWhere((element) => element.types!.contains('postal_code')).longName ?? "";
    }
    return null;
  }

  String? getAddress() {
    return mapsLoc?.adresses?.first.formattedAddress;
  }

  void checkCustomers(List<Customer> nearbyCustomers) {
    LatLng currentPos = LatLng(property.latitude!, property.longitude!);
    nearbyCustomers = nearbyCustomers.where((element) {
      LatLng coords1 = LatLng(element.cstmlatitude ?? 0.0, element.cstmlongitude ?? 0.0);
      double radius = Utils.calculateDistance(coords1, currentPos);
      element.radius = radius;
      return radius <= 100 && (element.cstmname?.toLowerCase() == formSource.cstmname.toLowerCase() || element.cstmaddress?.toLowerCase() == formSource.cstmaddress?.toLowerCase());
    }).toList();

    if (nearbyCustomers.isNotEmpty) {
      Customer customer = nearbyCustomers.first;
      Get.find<TaskHelper>().confirmPush(
        Task(
          nearbyCustomersID,
          message: "${customer.cstmname} already exists. Your customer will add to existing customer",
          onFinished: (res) {
            if (res) {
              bpCustomersHandler.fetcher.run(customer.cstmid!);
            }
          },
        ),
      );
    } else {
      Get.find<TaskHelper>().confirmPush(
        Task(
          nearbyCustomersID,
          message: "There is no customer with given name or address in your area, this customer will create as new customer",
          onFinished: (res) {
            if (res) {
              formSource.onSubmit();
            }
          },
        ),
      );
    }
  }

  List<BpCustomer> _customersSuccess(List data) {
    List<BpCustomer> customers = _customersFromList(
      data,
      LatLng(property.markers.first.position.latitude, property.markers.first.position.longitude),
    );
    property.deployCustomers(customers);
    return customers;
  }

  MapsLoc _locationSuccess(Map<String, dynamic> data) {
    MapsLoc mapsLoc = MapsLoc.fromJson(data);
    return mapsLoc;
  }

  void _placesSuccess(Map<String, dynamic> data) {
    if (data['province'] != null && data['city'] != null && data['subdistrict'] != null && data['village'] != null) {
      formSource.provinceid = Province.fromJson(data['province']).provid;
      formSource.cityid = City.fromJson(data['city']).cityid;
      formSource.subdistrictid = Subdistrict.fromJson(data['subdistrict']).subdistrictid;
      formSource.villageid = Village.fromJson(data['village']).villageid;
    } else {
      throw "The selected location is not available";
    }
  }

  Customer _customerSuccess(Map<String, dynamic> data) {
    Customer customer = Customer.fromJson(data);
    formSource.prepareFormValues();
    return customer;
  }

  void _customerComplete() {
    if (customer?.cstmsubdistrict != null) {
      String province = customer!.cstmprovince!.provname!;
      String city = customer!.cstmcity!.cityname!;
      String subdistrict = customer!.cstmsubdistrict!.subdistrictname!;
      String village = customer!.cstmuv!.villagename!;
      placesHandler.fetcher.run(village, subdistrict, city, province);
    }
  }

  void _nearbyCustomersSuccess(List data) {
    List<Customer> nearbyCustomers = List<Customer>.from(data.map((e) => Customer.fromJson(e)));
    checkCustomers(nearbyCustomers);
  }

  void _bpCustomersSuccess(List data) {
    List<BpCustomer> bpCustomers = List<BpCustomer>.from(data.map((e) => BpCustomer.fromJson(e)));
    if (bpCustomers.isEmpty) {
      formSource.onSubmit();
    } else {
      Get.find<TaskHelper>().failedPush(
        Task(
          bpCustomersID,
          message: "Customer already exist in your business partner",
        ),
      );
    }
  }

  void _createSuccess(String data) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: data,
        onFinished: (res) {
          Get.find<NearbyStateController>().refreshStates();
          Get.back(id: Views.nearby.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();

    userHandler = Utils.createDataHandler(userID, presenter.fetchUser, null, (data) => formSource.sbcbpid = UserDetail.fromJson(data).userdtbpid);
    customersHandler = Utils.createDataHandler(customersID, presenter.fetchCustomers, [], _customersSuccess);
    statusesHandler = Utils.createDataHandler(statusesID, presenter.fetchStatuses, {}, (data) => statusesFromList(data));
    typesHandler = Utils.createDataHandler(typesID, presenter.fetchTypes, {}, (data) => typesFromList(data));
    locationHandler = Utils.createDataHandler(locationID, presenter.fetchLocation, null, _locationSuccess,
        onComplete: () => placesHandler.fetcher.run(
              getVillageName()!,
              getSubdistrictName()!,
              getCityName()!,
              getProvinceName()!,
            ));
    placesHandler = Utils.createDataHandler(placesID, presenter.fetchPlaces, null, _placesSuccess);
    customerHandler = Utils.createDataHandler(customerID, presenter.fetchCustomer, null, _customerSuccess, onComplete: _customerComplete);

    nearbyCustomersHandler = DataHandler(
      nearbyCustomersID,
      initialValue: null,
      fetcher: presenter.fetchNearbyCustomers,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(nearbyCustomersID)),
      onFailed: (message) => Utils.showFailed(nearbyCustomersID, message, false),
      onError: (message) => Utils.showError(nearbyCustomersID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(nearbyCustomersID),
      onSuccess: _nearbyCustomersSuccess,
    );

    bpCustomersHandler = DataHandler(
      bpCustomersID,
      initialValue: null,
      fetcher: presenter.fetchBpCustomers,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(bpCustomersID)),
      onFailed: (message) => Utils.showFailed(bpCustomersID, message, false),
      onError: (message) => Utils.showError(bpCustomersID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(bpCustomersID),
      onSuccess: _bpCustomersSuccess,
    );

    createHandler = DataHandler(
      createID,
      initialValue: null,
      fetcher: presenter.create,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onFailed: (message) => Utils.showFailed(createID, message, false),
      onError: (message) => Utils.showError(createID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
      onSuccess: _createSuccess,
    );
  }

  @override
  CustomerFormCreatePresenter presenterBuilder() => CustomerFormCreatePresenter();
}
