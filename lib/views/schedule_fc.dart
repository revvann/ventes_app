// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/schedule_fc_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
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

class ScheduleFormCreateView extends RegularView<ScheduleFormCreateStateController> {
  static const String route = "/schedule/create";
  ScheduleFormCreateView() {
    $ = controller;
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
              RegularInput(
                label: "Title",
                hintText: "Enter title",
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              RegularSelectBox(
                label: "Type",
                onSelected: (value) {
                  $.typeActive = value;
                },
                activeIndex: $.typeActive,
                items: [
                  "Event",
                  "Task",
                  "Reminder",
                ],
              ),
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
                  return Stack(
                    children: [
                      Offstage(
                        offstage: $.typeActive != 0,
                        child: _buildEventForm(),
                      )
                    ],
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
        GestureDetector(
          onTap: () {
            RegularDatePicker(
              onSelected: (value) {
                if (value != null) {
                  $.dateStart = value;
                  $.dateStartTEC.text = DateFormat(viewDateFormat).format(value);
                }
              },
              initialdate: $.dateStart,
            ).show();
          },
          child: IconInput(
            icon: "assets/svg/calendar.svg",
            label: "Date Start",
            enabled: false,
            controller: $.dateStartTEC,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            RegularDatePicker(
              onSelected: (value) {
                if (value != null) {
                  $.dateEnd = value;
                  $.dateEndTEC.text = DateFormat(viewDateFormat).format(value);
                }
              },
              initialdate: $.dateEnd,
            ).show();
          },
          child: IconInput(
            icon: "assets/svg/calendar.svg",
            label: "Date End",
            enabled: false,
            controller: $.dateEndTEC,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Row(
          children: [
            Expanded(
              child: RegularDropdown<String?>(
                label: "Time Start",
                controller: $.timeStartSelectController,
                icon: "assets/svg/history.svg",
                onSelected: (value) {
                  $.createEndTimeList();
                },
              ),
            ),
            SizedBox(
              width: RegularSize.s,
            ),
            Expanded(
              child: RegularDropdown<String?>(
                label: "Time End",
                icon: "assets/svg/history.svg",
                controller: $.timeEndSelectController,
                onSelected: (value) {
                  DateTime time = DateTime.parse("0000-00-00 $value");
                  $.dateEnd = $.dateEnd.subtract(Duration(hours: $.dateEnd.hour, minutes: $.dateEnd.minute));
                  $.dateEnd = $.dateEnd.add(Duration(hours: time.hour, minutes: time.minute));
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        RegularCheckbox(
          label: "All Day",
          onChecked: $.allDayToggle,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            _showMapBottomSheet();
          },
          child: IconInput(
            icon: "assets/svg/marker.svg",
            label: "Location",
            hintText: "Choose location",
            controller: $.locationTEC,
            enabled: false,
          ),
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
                  $.currentPos = CameraPosition(target: $.markers.first.position, zoom: $.currentPos.zoom);
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
          $.locationTEC.text = "https://maps.google.com?q=${latLng.latitude},${latLng.longitude}";
          $.markers = {marker};
        },
      );
    });
  }
}
