// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/state_controllers/nearby_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/icon_input.dart';
import 'package:ventes/widgets/customer_card.dart';
import 'package:ventes/widgets/regular_button.dart';
import 'package:ventes/widgets/regular_dialog.dart';
import 'package:ventes/widgets/regular_time_picker.dart';
import 'package:ventes/widgets/top_navigation.dart';

class NearbyView extends RegularView<NearbyStateController> {
  static const String route = "/nearby";
  NearbyView() {
    $ = controller;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: "Nearby",
        height: 80,
        appBarKey: $.appBarKey,
        actions: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(RegularSize.xs),
              child: SvgPicture.asset(
                "assets/svg/filter.svg",
                width: RegularSize.l,
                color: Colors.white,
              ),
            ),
            onTap: _showFilter,
          ),
        ],
        below: Row(
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
            Text(
              "Cangkring, Klojen, Lamongan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ).build(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.m,
                ),
                constraints: BoxConstraints(
                  minHeight: $.minHeight,
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
                      height: RegularSize.m,
                    ),
                    IconInput(
                      icon: "assets/svg/search.svg",
                      hintText: "Search",
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    Text(
                      "Customers List",
                      style: TextStyle(
                        fontSize: 20,
                        color: RegularColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.xs,
                    ),
                    Text(
                      "10 Found",
                      style: TextStyle(
                        fontSize: 14,
                        color: RegularColor.dark,
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return CustomerCard(
                          image: AssetImage('assets/images/dummybg.jpg'),
                          margin: EdgeInsets.only(
                            bottom: 16,
                          ),
                          width: 220,
                          height: 270,
                          title: "PT. Ibu dan Anak",
                          type: "Manufacture Industry",
                          radius: "320 M",
                          workTime: "08.00-16.00",
                          place: "Periuk, Tangerang, Banten",
                        );
                      },
                    ),
                    SizedBox(
                      height: 75,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFilter() {
    RegularDialog(
      width: Get.width * 0.9,
      child: Column(
        children: [
          GestureDetector(
            onTap: $.changeTime,
            child: IconInput(
              label: "Visit Time",
              icon: "assets/svg/history.svg",
              hintText: "Visit Time",
              enabled: false,
              controller: $.filterTimeInputController,
            ),
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          RegularButton(
            label: "Apply",
            primary: RegularColor.secondary,
            height: RegularSize.xxl,
          ),
        ],
      ),
    ).show();
  }
}
