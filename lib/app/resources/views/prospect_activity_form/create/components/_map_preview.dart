part of 'package:ventes/app/resources/views/prospect_activity_form/create/prospect_activity_fc.dart';

class _MapPreview extends StatelessWidget {
  ProspectActivityFormCreateStateController state = Get.find<Controller>();

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
              markers: state.property.marker,
              onMapCreated: state.listener.onMapControllerCreated,
              scrollGesturesEnabled: false,
            );
          }),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return RegularInput(
            label: "Address",
            value: state.dataSource.locationAddress,
            enabled: false,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return RegularInput(
            label: "Location Link",
            value: state.formSource.prosdtloc,
            enabled: false,
          );
        }),
      ],
    );
  }
}
