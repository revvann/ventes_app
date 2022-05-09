// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state/controllers/nearby_state_controller.dart';

part 'package:ventes/app/resources/views/nearby/components/customer_list.dart';

class NearbyView extends RegularView<NearbyStateController> implements FetchDataContract {
  static const String route = "/nearby";
  NearbyView() {
    state = controller;
    state.properties.dataSource.fetchDataContract = this;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      key: state.properties.scaffoldKey,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: NearbyString.appBarTitle,
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
                    state.properties.dataSource.mapsLoc.adresses?.first.formattedAddress ?? "Unknown",
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
                  initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 14.4764),
                  markers: state.properties.markers,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    if (!state.properties.mapsController.isCompleted) {
                      state.properties.mapsController.complete(controller);
                    }
                  },
                  onCameraMove: (position) {
                    state.properties.markerLatLng = position.target;
                  },
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
                      return Container(
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

  @override
  onLoadError(String message) {
    Get.close(1);
    FailedAlert(NearbyString.fetchError).show();
  }

  @override
  onLoadFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.fetchFailed).show();
  }

  @override
  onLoadSuccess(Map data) {
    if (data['location'] != null) {
      state.properties.dataSource.locationDetailLoaded(data['location'] as Map<String, dynamic>);
    }

    if (data['customers'] != null) {
      state.properties.deployCustomers(data['customers']);
    }
    Get.close(1);
  }
}
