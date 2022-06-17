part of 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';

class CustomerFormUpdateFormSource extends UpdateFormSource {
  CustomerFormUpdateValidator validator = CustomerFormUpdateValidator();
  final CustomerFormUpdateProperty _properties = Get.find<CustomerFormUpdateProperty>(tag: NearbyString.customerUpdateTag);
  final CustomerFormUpdateDataSource _dataSource = Get.find<CustomerFormUpdateDataSource>(tag: NearbyString.customerUpdateTag);

  SearchListController<Country, Country> countrySearchListController = Get.put(SearchListController<Country, Country>());
  SearchListController<Province, Province> provinceSearchListController = Get.put(SearchListController<Province, Province>());
  SearchListController<City, City> citySearchListController = Get.put(SearchListController<City, City>());
  SearchListController<Subdistrict, Subdistrict> subdistrictSearchListController = Get.put(SearchListController<Subdistrict, Subdistrict>());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<Image> defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController postalCodeTEC = TextEditingController();

  File? picture;
  int? sbcid;
  String cstmlatitude = '0';
  String cstmlongitude = '0';
  int? sbccstmstatusid;

  final Rx<int?> _cstmtypeid = Rx<int?>(null);

  int? get cstmtypeid => _cstmtypeid.value;
  String get cstmname => nameTEC.text;
  String get cstmaddress => addressTEC.text;
  String get cstmphone => phoneTEC.text;
  String get cstmpostalcode => postalCodeTEC.text;
  String? get cstmcoutryid => countrySearchListController.selectedItem?.countryid.toString();
  String? get cstmprovinceid => provinceSearchListController.selectedItem?.provid.toString();
  String? get cstmcityid => citySearchListController.selectedItem?.cityid.toString();
  String? get cstmsubdistrictid => subdistrictSearchListController.selectedItem?.subdistrictid.toString();

  Country? get country => countrySearchListController.selectedItem;
  Province? get province => provinceSearchListController.selectedItem;
  City? get city => citySearchListController.selectedItem;
  Subdistrict? get subdistrict => subdistrictSearchListController.selectedItem;

  set cstmtypeid(int? value) => _cstmtypeid.value = value;

  @override
  void close() {
    super.close();
    nameTEC.dispose();
    addressTEC.dispose();
    phoneTEC.dispose();
    postalCodeTEC.dispose();
    Get.delete<SearchListController<Country, Country>>();
    Get.delete<SearchListController<Province, Province>>();
    Get.delete<SearchListController<City, City>>();
    Get.delete<SearchListController<Subdistrict, Subdistrict>>();
  }

  @override
  void prepareFormValues() {
    if (_dataSource.bpCustomer != null) {
      sbcid = _dataSource.bpCustomer!.sbcid;

      cstmlatitude = _dataSource.bpCustomer!.sbccstm!.cstmlatitude!.toString();
      cstmlongitude = _dataSource.bpCustomer!.sbccstm!.cstmlongitude!.toString();
      _properties.markerLatLng = LatLng(double.parse(cstmlatitude), double.parse(cstmlongitude));

      nameTEC.text = _dataSource.bpCustomer!.sbccstm!.cstmname ?? "";
      addressTEC.text = _dataSource.bpCustomer!.sbccstm!.cstmaddress ?? "";
      phoneTEC.text = _dataSource.bpCustomer!.sbccstm!.cstmphone ?? "";
      postalCodeTEC.text = _dataSource.bpCustomer!.sbccstm!.cstmpostalcode ?? "";

      cstmtypeid = _dataSource.bpCustomer!.sbccstm!.cstmtypeid;

      if (_dataSource.bpCustomer!.sbccstmpic != null) {
        defaultPicture.value = Image.network(_dataSource.bpCustomer!.sbccstmpic!);
      }

      if (_dataSource.bpCustomer!.sbccstm!.cstmcountry != null) {
        countrySearchListController.selectedItem = _dataSource.bpCustomer!.sbccstm!.cstmcountry!;
      }

      if (_dataSource.bpCustomer!.sbccstm!.cstmprovince != null) {
        provinceSearchListController.selectedItem = _dataSource.bpCustomer!.sbccstm!.cstmprovince!;
      }

      if (_dataSource.bpCustomer!.sbccstm!.cstmcity != null) {
        citySearchListController.selectedItem = _dataSource.bpCustomer!.sbccstm!.cstmcity!;
      }

      if (_dataSource.bpCustomer!.sbccstm!.cstmsubdistrict != null) {
        subdistrictSearchListController.selectedItem = _dataSource.bpCustomer!.sbccstm!.cstmsubdistrict!;
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sbccstmpic': picture?.path,
      'sbccstmstatusid': sbccstmstatusid,
      'cstmname': cstmname,
      'cstmaddress': cstmaddress,
      'cstmphone': cstmphone,
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };
  }

  @override
  void onSubmit() {
    double newLat = double.tryParse(cstmlatitude) ?? 0.0;
    double newLng = double.tryParse(cstmlongitude) ?? 0.0;
    LatLng newPos = LatLng(newLat, newLng);

    double radius = calculateDistance(_properties.markers.first.position, newPos);
    bool inRange = radius <= 100;

    if (isValid && inRange) {
      Map<String, dynamic> data = toJson();
      data['_method'] = 'PUT';

      if (data['sbccstmpic'] != null) {
        String filename = path.basename(data['sbccstmpic']);
        data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);
      }

      FormData formData = FormData(data);
      _dataSource.updateCustomer(sbcid!, formData);
      Get.find<TaskHelper>().loaderPush(_properties.task);
    } else {
      Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: NearbyString.formInvalid));
    }
  }
}
