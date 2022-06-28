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
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/view/view.dart';

part 'package:ventes/app/resources/views/customer_form/create/components/_customer_picture.dart';
part 'package:ventes/app/resources/views/customer_form/create/components/_form.dart';
part 'package:ventes/app/resources/views/customer_form/create/components/_place_picker.dart';

class CustomerFormCreateView extends View<Controller> {
  static const String route = "/customer/create";
  double? latitude;
  double? longitude;
  int? cstmid;

  CustomerFormCreateView({this.latitude, this.longitude, this.cstmid});

  @override
  void onBuild(state) {
    state.property.latitude = latitude;
    state.property.longitude = longitude;
    state.property.cstmid = cstmid;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: NearbyString.appBarTitle,
        appBarKey: state.appBarKey,
        onTitleTap: () async => state.refreshStates(),
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
        child: RefreshIndicator(
          onRefresh: () async => state.refreshStates(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              right: RegularSize.m,
              left: RegularSize.m,
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
              child: _CustomerForm(),
            ),
          ),
        ),
      ),
    );
  }
}
