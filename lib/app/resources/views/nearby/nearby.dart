// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/pop_up_item.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/resources/views/nearby/components/customer_list.dart';
part 'package:ventes/app/resources/views/nearby/components/_app_bar_menu.dart';

class NearbyView extends View<Controller> {
  static const String route = "/nearby";

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      key: state.property.scaffoldKey,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: NearbyString.appBarTitle,
        onTitleTap: () async => state.refreshStates(),
        height: 80,
        appBarKey: state.appBarKey,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: backToDashboard,
        ),
        actions: [
          _AppBarMenu(),
          SizedBox(width: RegularSize.xs),
        ],
        below: Container(
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.xl,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(RegularSize.xs),
                child: SvgPicture.asset(
                  "assets/svg/marker.svg",
                  width: RegularSize.m,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Obx(() {
                  return Text(
                    state.dataSource.mapsLoc.adresses?.first.formattedAddress ?? "Unknown",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: Stack(
          key: state.property.stackKey,
          children: [
            Obx(() {
              return Container(
                width: double.infinity,
                height: state.property.mapsHeight.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: state.property.defaultZoom),
                  markers: state.property.markers,
                  myLocationEnabled: true,
                  onMapCreated: state.listener.onMapControllerCreated,
                  onCameraMove: state.listener.onCameraMoved,
                  onCameraIdle: state.listener.onCameraMoveEnd,
                ),
              );
            }),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              snap: true,
              snapSizes: [
                1.0,
              ],
              builder: (BuildContext context, myscrollController) {
                return Container(
                  key: state.property.bottomSheetKey,
                  padding: EdgeInsets.only(
                    top: RegularSize.l,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(RegularSize.xl),
                      topRight: Radius.circular(RegularSize.xl),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: myscrollController,
                    child: Obx(() {
                      return SizedBox(
                        height: state.property.bottomSheetHeight.value,
                        child: Column(
                          children: [
                            Text(
                              NearbyString.bottomSheetTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: RegularSize.xs,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: RegularSize.m,
                              ),
                              child: IconInput(
                                icon: "assets/svg/search.svg",
                                hintText: "Search",
                              ),
                            ),
                            SizedBox(
                              height: RegularSize.s,
                            ),
                            _CustomerList(),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
