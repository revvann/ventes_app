// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/signin_string.dart';
import 'package:ventes/app/network/contracts/auth_contract.dart';
import 'package:ventes/app/states/controllers/signin_state_controller.dart';
import 'package:ventes/app/resources/views/dashboard.dart';
import 'package:ventes/core/regular_view.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/app/resources/widgets/regular_button.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';

part 'package:ventes/app/resources/views/signin/components/_username_input.dart';
part 'package:ventes/app/resources/views/signin/components/_password_input.dart';

class SigninView extends View<SigninStateController> implements AuthContract {
  static const String route = "/signin";

  SigninView() {
    state.dataSource.authContract = this;
  }

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
                      color: RegularColor.secondary,
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
                        color: RegularColor.gray,
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
                primary: RegularColor.secondary,
                label: "Sign In",
                height: RegularSize.xxl,
                onPressed: () {
                  _showBottomSheet();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    RegularBottomSheet(
      backgroundColor: Colors.white,
      child: Form(
        key: state.formSource.key,
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
                color: RegularColor.secondary,
              ),
            ),
            SizedBox(
              height: RegularSize.m,
            ),
            _UsernameInput(
              controller: state.formSource.usernameTEC,
            ),
            SizedBox(
              height: RegularSize.m,
            ),
            _PasswordInput(
              controller: state.formSource.passwordTEC,
            ),
            SizedBox(
              height: RegularSize.xl,
            ),
            Obx(() {
              return RegularButton(
                primary: RegularColor.secondary,
                isLoading: state.dataSource.isLoading,
                label: SigninString.signinButton,
                height: RegularSize.xxl,
                onPressed: state.formSubmit,
              );
            }),
          ],
        ),
      ),
    ).show();
  }

  @override
  void onAuthFailed(String message) {
    state.dataSource.isLoading = false;
    RegularDialog(
      width: Get.width * 0.7,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Sign In Failed",
                    style: TextStyle(
                      fontSize: 18,
                      color: RegularColor.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.close(1);
                },
                child: SvgPicture.asset(
                  'assets/svg/close.svg',
                  width: 15,
                ),
              ),
            ],
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          Text(
            "Credentials not found, make sure your username and password are correct.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RegularColor.dark,
              fontSize: 14,
            ),
          )
        ],
      ),
    ).show();
  }

  @override
  void onAuthSuccess(String message) {
    state.dataSource.isLoading = false;
    Get.offAllNamed(DashboardView.route);
  }
}
