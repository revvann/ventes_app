// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/resources/views/nearby/components/customer_list.dart';

class NearbyView extends View<NearbyStateController> {
  static const String route = "/nearby";

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      key: state.properties.scaffoldKey,
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
          Obx(() {
            bool isCustomerSelected = state.properties.selectedCustomer.isNotEmpty;
            bool isBpHasCustomer = false;
            if (state.dataSource.bpCustomers.isNotEmpty && state.properties.selectedCustomer.isNotEmpty) {
              isBpHasCustomer = state.dataSource.bpCustomersHas(state.properties.selectedCustomer.first);
            }
            return GestureDetector(
              onTap: isCustomerSelected
                  ? isBpHasCustomer
                      ? state.listener.onEditDataClick
                      : state.listener.onAddDataClick
                  : state.listener.onAddDataClick,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: RegularSize.s,
                  horizontal: RegularSize.m,
                ),
                child: Text(
                  isCustomerSelected
                      ? isBpHasCustomer
                          ? NearbyString.editCustomerText
                          : NearbyString.addCustomerText
                      : NearbyString.addCustomerText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }),
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
          key: state.properties.stackKey,
          children: [
            Obx(() {
              return Container(
                width: double.infinity,
                height: state.properties.mapsHeight.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: state.properties.defaultZoom),
                  markers: state.properties.markers,
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
                  key: state.properties.bottomSheetKey,
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
                        height: state.properties.bottomSheetHeight.value,
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
