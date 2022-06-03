// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/regular_button.dart';
import 'package:ventes/app/states/controllers/settings_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/helpers/notification_helper.dart';

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
              RegularButton(
                label: "Press on me",
                height: RegularSize.xl,
                primary: RegularColor.red,
                onPressed: () {
                  Get.find<NotificationHelper>().scheduleNotification(
                    title: "Ventes",
                    body: "Metting with supervisor will be held at 10:00 AM, dont miss it",
                    payload: "1",
                    scheduledDate: DateTime.now().add(Duration(seconds: 10)),
                    timeZone: "Asia/Bangkok",
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
