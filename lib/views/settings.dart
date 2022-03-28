// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/state_controllers/settings_state_controller.dart';
import 'package:ventes/views/regular_view.dart';

class SettingsView extends RegularView<SettingsStateController> {
  static const String route = "/settings";
  SettingsView() {
    $ = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
