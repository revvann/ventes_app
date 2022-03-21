// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/state_controllers/signin_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/regular_bottom_sheet.dart';
import 'package:ventes/widgets/regular_button.dart';
import 'package:ventes/widgets/regular_input.dart';

class SigninView extends RegularView<SigninStateController> {
  static const String route = "/signin";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(
            RegularSize.m,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: Get.height * 0.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/welcome.svg',
                    ),
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: RegularColor.dark_1,
                    ),
                  ),
                  SizedBox(
                    height: RegularSize.m,
                  ),
                  Container(
                    width: Get.width * 0.80,
                    alignment: Alignment.center,
                    child: Text(
                      "Please sign in first before use this app. Make sure your email and password are correct.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: RegularColor.gray_3,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              RegularButton(
                label: "Sign In",
                height: RegularSize.xxl,
                onPressed: () {
                  RegularBottomSheet(
                    backgroundColor: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: RegularColor.primary,
                          ),
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Email",
                          inputType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Password",
                          isPassword: true,
                        ),
                        SizedBox(
                          height: RegularSize.xl,
                        ),
                        RegularButton(
                          label: "Sign In",
                          height: RegularSize.xxl,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ).show();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
