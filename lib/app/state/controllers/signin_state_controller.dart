import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/network/presenters/auth_presenter.dart';
import 'package:ventes/app/state/controllers/regular_state_controller.dart';
import 'package:ventes/app/state/data_sources/signin_data_source.dart';
import 'package:ventes/app/state/form_sources/signin_form_source.dart';

class SigninStateController extends RegularStateController {
  @override
  bool get isFixedBody => false;

  SigninFormSource formSource = SigninFormSource();
  SigninDataSource dataSource = SigninDataSource();

  void formSubmit() {
    if (formSource.formValid) {
      Map<String, dynamic> credentials = formSource.toJson();
      dataSource.signin(credentials);
    }
  }

  @override
  onInit() {
    super.onInit();
    formSource.init();
  }

  @override
  dispose() {
    formSource.dispose();
    super.dispose();
  }
}
