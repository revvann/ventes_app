import 'package:flutter/material.dart';
import 'package:ventes/widgets/regular_input.dart';

class SigninFormSource {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _usernameTEC = TextEditingController();

  String get password => _passwordTEC.text;
  String get username => _usernameTEC.text;

  bool get formValid => key.currentState?.validate() ?? false;

  void dispose() {
    _passwordTEC.dispose();
    _usernameTEC.dispose();
  }

  Widget get usernameInput {
    return RegularInput(
      maxLines: 1,
      controller: _usernameTEC,
      hintText: "Enter your username",
      label: "Username",
      inputType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return "Username can't be empty";
      },
    );
  }

  Widget get passwordInput {
    return RegularInput(
      maxLines: 1,
      controller: _passwordTEC,
      hintText: "Enter your password",
      label: "Password",
      isPassword: true,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length >= 6) {
            return null;
          }
          return "Password must be at least 6 characters";
        }
        return "Password can't be empty";
      },
    );
  }
}
