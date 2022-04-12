import 'package:flutter/material.dart';
import 'package:ventes/state_controllers/signin_state_controller.dart';

class SigninFormSource {
  late final SigninStateController $;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  String get password => $.passwordTEC.text;
  String get username => $.usernameTEC.text;
  bool get formValid => key.currentState?.validate() ?? false;

  set stateController(SigninStateController controller) {
    $ = controller;
  }
}
