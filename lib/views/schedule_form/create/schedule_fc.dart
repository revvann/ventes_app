// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/contracts/fetch_data_contract.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/views/schedule_form/create/schedule_fc_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/editor_input.dart';
import 'package:ventes/widgets/field_dropdown.dart';
import 'package:ventes/widgets/regular_bottom_sheet.dart';
import 'package:ventes/widgets/regular_button.dart';
import 'package:ventes/widgets/regular_checkbox.dart';
import 'package:ventes/widgets/regular_date_picker.dart';
import 'package:ventes/widgets/regular_dropdown.dart';
import 'package:ventes/widgets/regular_outlined_button.dart';
import 'package:ventes/widgets/regular_select_box.dart';
import 'package:ventes/widgets/icon_input.dart';
import 'package:ventes/widgets/regular_input.dart';
import 'package:ventes/widgets/top_navigation.dart';

class ScheduleFormCreateView
    extends RegularView<ScheduleFormCreateStateController>
    implements FetchDataContract {
  static const String route = "/schedule/create";
  ScheduleFormCreateView() {
    $ = controller;
    $.presenter.fetchDataContract = this;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        height: 85,
        title: "Schedule",
        appBarKey: $.appBarKey,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Get.back(id: ScheduleNavigator.id);
          },
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: RegularSize.s,
              horizontal: RegularSize.m,
            ),
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
        below: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Form Create",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.m,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RegularSize.xl),
              topRight: Radius.circular(RegularSize.xl),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: RegularSize.l,
              ),
              Text(
                "General",
                style: TextStyle(
                  color: RegularColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              $.formSource.titleInput,
              SizedBox(
                height: RegularSize.m,
              ),
              $.formSource.scheduleTypeSelectbox,
              SizedBox(
                height: RegularSize.l,
              ),
              Text(
                "More Options",
                style: TextStyle(
                  color: RegularColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: Obx(() {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Offstage(
                          offstage: $.formSource.scheduleType.index != 0,
                          child: _buildEventForm(),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventForm() {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.dateStartInput,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.dateEndInput,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.twinTimeInput,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.allDayCheckbox,
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            if (!$.formSource.online) {
              _showMapBottomSheet();
            }
          },
          child: $.formSource.locationInput,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.onlineCheckbox,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.linkInput,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.remindInput,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.descriptionInput,
        SizedBox(
          height: RegularSize.m,
        ),
        $.formSource.guestDropdown,
        SizedBox(
          height: RegularSize.m,
        ),
      ],
    );
  }

  void _showMapBottomSheet() {
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
                  if ($.markers.isNotEmpty) {
                    $.currentPos = CameraPosition(
                        target: $.markers.first.position,
                        zoom: $.currentPos.zoom);
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
          Container(
            height: Get.height * 0.4,
            child: _buildMap(),
          ),
          SizedBox(
            height: RegularSize.m,
          ),
        ],
      ),
    ).show();
  }

  Widget _buildMap() {
    return Obx(() {
      return GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: $.currentPos,
        markers: $.markers,
        onMapCreated: (GoogleMapController controller) {
          if (!$.mapsController.isCompleted) {
            $.mapsController.complete(controller);
          }
        },
        onTap: (latLng) {
          Marker marker = Marker(
            markerId: MarkerId("selectedloc"),
            infoWindow: InfoWindow(title: "Selected Location"),
            position: latLng,
          );
          $.formSource.location =
              "https://maps.google.com?q=${latLng.latitude},${latLng.longitude}";
          $.markers = {marker};
        },
      );
    });
  }

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}
}
