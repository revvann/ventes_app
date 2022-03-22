import 'package:flutter/material.dart';
import 'package:ventes/state_controllers/main_state_controller.dart';
import 'package:ventes/views/regular_view.dart';

class MainView extends RegularView<MainStateController> {
  static const route = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}
