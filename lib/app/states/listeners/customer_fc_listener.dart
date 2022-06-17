part of 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';

class CustomerFormCreateListener extends StateListener {
  CustomerFormCreateProperty get _properties => Get.find<CustomerFormCreateProperty>(tag: NearbyString.customerCreateTag);
  CustomerFormCreateFormSource get _formSource => Get.find<CustomerFormCreateFormSource>(tag: NearbyString.customerCreateTag);
  CustomerFormCreateDataSource get _dataSource => Get.find<CustomerFormCreateDataSource>(tag: NearbyString.customerCreateTag);

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }

  bool onCountryCompared(Country country, Country? selected) {
    return country.countryid == selected?.countryid;
  }

  bool onProvinceCompared(Province province, Province? selected) {
    return province.provid == selected?.provid;
  }

  bool onCityCompared(City city, City? selected) {
    return city.cityid == selected?.cityid;
  }

  bool onSubdistrictCompared(Subdistrict subdistrict, Subdistrict? selected) {
    return subdistrict.subdistrictid == selected?.subdistrictid;
  }

  void onTypeSelected(int type) {
    _formSource.cstmtypeid = type;
  }

  void onStatusSelected(int status) {
    _formSource.sbccstmstatusid = status;
  }

  void onMapControllerCreated(GoogleMapController controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  Future onCountryFilter(String? search) async {
    List<Country> countries = await _dataSource.fetchCountries(search);
    return countries;
  }

  void onPicturePicked() async {
    ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _formSource.picture = File(image.path);
      _formSource.defaultPicture.value = Image.file(_formSource.picture!);
    }
  }

  void onSubmitButtonClicked() async {
    Get.find<TaskHelper>().confirmPush(
      _properties.task.copyWith<bool>(
        message: NearbyString.createCustomerConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onCreateDataSuccess(String message) async {
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().properties.refresh();
          Get.back(id: NearbyNavigator.id);
        }));
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
