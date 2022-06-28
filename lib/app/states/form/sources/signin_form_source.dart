import 'package:flutter/material.dart' hide MenuItem;

class SigninFormSource {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController passwordTEC = TextEditingController();
  final TextEditingController usernameTEC = TextEditingController();

  late String _username;
  late String _password;

  String get password => _password;
  String get username => _username;
  bool get formValid => key.currentState?.validate() ?? false;

  init() {
    passwordTEC.addListener(() => _password = passwordTEC.text);
    usernameTEC.addListener(() => _username = usernameTEC.text);
  }

  dispose() {
    passwordTEC.dispose();
    usernameTEC.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
