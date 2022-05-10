import 'package:flutter/material.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/state/controllers/example_state_controller.dart';

class ExampleView extends RegularView<ExampleStateController> {
  static const String route = "/example";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
