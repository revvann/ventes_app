import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/presenters/auth_presenter.dart';

class SigninStateController extends GetxController {
  AuthPresenter presenter = AuthPresenter();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController usernameTEC = TextEditingController();

  final _authProcessing = false.obs;
  bool get authProcessing => _authProcessing.value;
  set authProcessing(bool value) => _authProcessing.value = value;

  void formSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      String password = passwordTEC.text;
      String username = usernameTEC.text;
      authProcessing = true;
      presenter.signIn(username, password);
    }
  }
}
