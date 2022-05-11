import 'package:flutter/material.dart';
import 'package:ventes/core/regular_view.dart';
import 'package:ventes/app/states/controllers/example_state_controller.dart';

class ExampleView extends View<ExampleStateController> {
  static const String route = "/example";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
