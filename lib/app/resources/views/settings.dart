// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ventes/app/states/controllers/settings_state_controller.dart';
import 'package:ventes/core/view.dart';

class SettingsView extends View<SettingsStateController> {
  static const String route = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                child: Text('SUBMIT'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
