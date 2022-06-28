// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
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
  }) : super(key: key);
  EdgeInsets? margin;
  double width;
  double height;
  String name;
  String customer;
  String owner;
  String status;
  String date;

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
