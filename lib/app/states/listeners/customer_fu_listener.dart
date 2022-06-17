part of 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: NearbyString.customerUpdateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: NearbyString.customerUpdateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: NearbyString.customerUpdateTag);

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }

  void onTypeSelected(int type) {
    _formSource.cstmtypeid = type;
  }

  void onMapControllerUpdated(GoogleMapController controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    _properties.markerLatLng = position.target;
    _formSource.cstmlatitude = position.target.latitude.toString();
    _formSource.cstmlongitude = position.target.longitude.toString();
  }

  void onCameraMoveEnd() {
    _properties.cameraMoveType = CameraMoveType.dragged;
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

  void onStatusSelected(int status) {
    _formSource.sbccstmstatusid = status;
  }

  void onSubmitButtonClicked() async {
    Get.find<TaskHelper>().confirmPush(
      _properties.task.copyWith<bool>(
        message: NearbyString.updateCustomerConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onUpdateDataSuccess(String message) async {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().properties.refresh();
          Get.back(id: NearbyNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }
}
