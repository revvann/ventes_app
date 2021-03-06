// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/keyable_selectbox.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';
import 'package:ventes/app/states/typedefs/customer_fu_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/view/view.dart';

part 'package:ventes/app/resources/views/customer_form/update/components/_customer_picture.dart';
part 'package:ventes/app/resources/views/customer_form/update/components/_form.dart';
part 'package:ventes/app/resources/views/customer_form/update/components/_bottomsheet.dart';

class CustomerFormUpdateView extends View<Controller> {
  static const String route = "/customer/update";
  int customerid;

  CustomerFormUpdateView(this.customerid);

  @override
  void onBuild(state) {
    state.property.customerid = customerid;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: state.property.scaffoldKey,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: NearbyString.appBarTitle,
        onTitleTap: () async => state.refreshStates(),
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
                  onMapCreated: state.listener.onMapControllerUpdated,
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
