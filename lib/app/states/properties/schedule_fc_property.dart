part of 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';

class ScheduleFormCreateProperty extends StateProperty {
  ScheduleFormCreateDataSource get _dataSource => Get.find<ScheduleFormCreateDataSource>(tag: ScheduleString.scheduleCreateTag);
  ScheduleFormCreateListener get _listener => Get.find<ScheduleFormCreateListener>(tag: ScheduleString.scheduleCreateTag);
  ScheduleFormCreateFormSource get _formSource => Get.find<ScheduleFormCreateFormSource>(tag: ScheduleString.scheduleCreateTag);

  final Completer<GoogleMapController> mapsController = Completer();
  CameraPosition currentPos = CameraPosition(target: LatLng(0, 0), zoom: 14.4764);

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});

  Task task = Task(ScheduleString.createScheduleTaskCode);

  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;
  set markerLatLng(LatLng latlng) {
    Marker marker = Marker(
      markerId: MarkerId("selectedloc"),
      infoWindow: InfoWindow(title: "Selected Location"),
      position: latlng,
    );
    markers = {marker};
  }

  void refresh() async {
    Get.find<TaskHelper>().loaderPush(task);
    Position pos = await getCurrentPosition();
    mapsController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
      );
    });
    markerLatLng = LatLng(pos.latitude, pos.longitude);
    _dataSource.fetchTypes();
  }

  void showMapBottomSheet() {
    RegularBottomSheet(
      backgroundColor: Colors.white,
      enableDrag: false,
      child: Column(
        children: [
          SizedBox(
            height: RegularSize.m,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: RegularColor.secondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (markers.isNotEmpty) {
                    currentPos = CameraPosition(target: markers.first.position, zoom: currentPos.zoom);
                  }
                  Get.close(1);
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    color: RegularColor.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          SizedBox(
            height: Get.height * 0.4,
            child: _gMaps,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
        ],
      ),
    ).show();
  }

  Widget get _gMaps {
    return Obx(() {
      return GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: currentPos,
        markers: markers,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          if (!mapsController.isCompleted) {
            mapsController.complete(controller);
          }
        },
        onCameraMove: _listener.onCameraMove,
      );
    });
  }

  Future scheduleNotification() async {
    if (_formSource.isEvent && _formSource.scheremind != 0) {
      String title = "Ventes Schedule";
      DateTime? startTime = _formSource.schestarttime;
      DateTime? startDate = _formSource.schestartdate;
      DateTime date;

      if (!_formSource.scheallday) {
        date = DateTime(startDate.year, startDate.month, startDate.day, startTime!.hour, startTime.minute);
      } else {
        date = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
      }

      date = date.subtract(Duration(minutes: _formSource.scheremind));

      String message = "${_formSource.schenm} will start in ${_formSource.scheremind} minutes, be ready!";

      await Get.find<NotificationHelper>().scheduleNotification(
        title: title,
        body: message,
        scheduledDate: date,
        timeZone: _formSource.schetz,
      );
    }
  }
}
