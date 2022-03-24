// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/state_controllers/contact_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/IconInput.dart';

class ContactView extends RegularView<ContactStateController> {
  static const String route = "/contact";
  ContactView() {
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
      appBar: AppBar(
        key: $.appBarKey,
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: RegularColor.primary,
        elevation: 0,
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
            Get.back();
          },
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/plus-bold.svg",
              width: RegularSize.l,
              color: Colors.white,
            ),
          ),
          SizedBox(width: RegularSize.m),
        ],
        title: Text(
          "Contacts",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
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
                      "Contacts List",
                      style: TextStyle(
                        fontSize: 20,
                        color: RegularColor.primary,
                        fontWeight: FontWeight.w600,
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
                        return Container(
                          height: 75,
                          margin: EdgeInsets.only(
                            bottom: RegularSize.s,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: RegularSize.s,
                            vertical: RegularSize.s,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: RegularColor.disable,
                            ),
                            borderRadius: BorderRadius.circular(RegularSize.m),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                color: Color(0xFF0157E4).withOpacity(0.1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(RegularSize.m),
                                child: Image.asset(
                                  'assets/images/dummyavatar.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: RegularSize.m,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Suhadi Aziz Effendi S.Kom",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: RegularColor.dark,
                                        ),
                                      ),
                                      Text(
                                        "Office Boy",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: RegularColor.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/building.svg',
                                        width: RegularSize.m,
                                        color: RegularColor.primary,
                                      ),
                                      SizedBox(width: RegularSize.xs),
                                      Text(
                                        "PT. Mencari Jati Diri",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: RegularColor.dark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
}
