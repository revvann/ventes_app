// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';

class _PlacePicker extends StatelessWidget {
  CustomerFormCreateStateController get state => Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Obx(() {
            return GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: state.property.defaultZoom),
              markers: state.property.markers,
              myLocationEnabled: true,
              onMapCreated: state.listener.onMapControllerCreated,
              scrollGesturesEnabled: false,
            );
          }),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Row(
          children: [
            Expanded(
              child: RegularInput(
                label: "Latitude",
                enabled: false,
                controller: state.formSource.latitudeTEC,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: RegularSize.s,
            ),
            Expanded(
              child: RegularInput(
                label: "Longitude",
                enabled: false,
                controller: state.formSource.longitudeTEC,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
