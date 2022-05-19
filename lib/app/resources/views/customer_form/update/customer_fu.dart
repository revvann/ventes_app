// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/input_search_list.dart';
import 'package:ventes/app/resources/widgets/keyable_selectbox.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/view.dart';

part 'package:ventes/app/resources/views/customer_form/update/components/_customer_picture.dart';
part 'package:ventes/app/resources/views/customer_form/update/components/_form.dart';
part 'package:ventes/app/resources/views/customer_form/update/components/_search_list.dart';
part 'package:ventes/app/resources/views/customer_form/update/components/_bottomsheet.dart';

class CustomerFormUpdateView extends View<CustomerFormUpdateStateController> {
  static const String route = "/customer/update";

  CustomerFormUpdateView(int customerid) {
    state.properties.customerid = customerid;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: state.properties.scaffoldKey,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: NearbyString.appBarTitle,
        onTitleTap: state.listener.onRefresh,
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
          onTap: state.listener.goBack,
        ),
        actions: [
          GestureDetector(
            onTap: state.listener.onSubmitButtonClicked,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
                horizontal: RegularSize.m,
              ),
              child: Text(
                NearbyString.formSubmitButton,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
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
            _BottomSheet(
              child: _CustomerForm(),
            ),
          ],
        ),
      ),
    );
  }
}
