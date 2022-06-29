// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/app/resources/widgets/pop_up_item.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class ProspectCard extends StatelessWidget {
  ProspectCard({
    Key? key,
    this.margin,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.name,
    required this.customer,
    required this.status,
    required this.owner,
    required this.date,
    this.usePopup = true,
    this.popupController,
    this.popupItems = const [],
  }) : super(key: key);
  EdgeInsets? margin;
  double width;
  double height;
  String name;
  String customer;
  String owner;
  String status;
  String date;
  PopupMenuController? popupController;
  bool usePopup;
  List<MenuItem> popupItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RegularSize.m),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Color(0xFF0157E4).withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: RegularSize.m,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: RegularColor.dark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              customer,
                              style: TextStyle(
                                fontSize: 14,
                                color: RegularColor.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: RegularSize.xs,
                            ),
                            Text(
                              owner,
                              style: TextStyle(
                                color: RegularColor.dark,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: RegularSize.xs,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: RegularSize.xs,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: RegularSize.s,
                              vertical: RegularSize.xs,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: RegularColor.green,
                              borderRadius: BorderRadius.circular(RegularSize.s),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (usePopup)
                            PopupMenu(
                              controller: popupController!,
                              dropdownSettings: DropdownSettings(
                                width: 150,
                                offset: Offset(10, 5),
                                builder: (controller) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: RegularSize.s,
                                    horizontal: RegularSize.s,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: popupItems,
                                  ),
                                ),
                              ),
                              child: Container(
                                width: 20,
                                height: 20,
                                margin: EdgeInsets.only(
                                  left: RegularSize.s,
                                ),
                                padding: EdgeInsets.all(RegularSize.xs),
                                alignment: Alignment.center,
                                child: Transform.rotate(
                                  angle: pi / 2,
                                  child: SvgPicture.asset(
                                    "assets/svg/menu-dots.svg",
                                    color: RegularColor.dark,
                                    width: RegularSize.m,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Text(
                        date,
                        style: TextStyle(
                          color: RegularColor.dark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: RegularSize.m,
          ),
        ],
      ),
    );
  }
}
