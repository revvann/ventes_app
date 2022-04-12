import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/presenters/auth_presenter.dart';
import 'package:ventes/form_sources/signin_form_source.dart';

class SigninStateController extends GetxController {
  AuthPresenter presenter = AuthPresenter();
  SigninFormSource formSource = SigninFormSource();

  final TextEditingController passwordTEC = TextEditingController();
  final TextEditingController usernameTEC = TextEditingController();

  final _authProcessing = false.obs;
  bool get authProcessing => _authProcessing.value;
  set authProcessing(bool value) => _authProcessing.value = value;

  void formSubmit() {
    if (formSource.formValid) {
      String password = formSource.password;
      String username = formSource.username;
      authProcessing = true;
      presenter.signIn(username, password);
    }
  }

  @override
  onInit() {
    super.onInit();
    formSource.stateController = this;
  }

  @override
  dispose() {
    usernameTEC.dispose();
    passwordTEC.dispose();
    super.dispose();
  }
}
