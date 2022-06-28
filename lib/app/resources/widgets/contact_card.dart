// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class ContactCard extends StatelessWidget {
  ContactCard({
    Key? key,
    required this.avatar,
    required this.name,
    required this.job,
    required this.company,
  }) : super(key: key);
  String avatar;
  String name;
  String job;
  String company;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: EdgeInsets.only(
        bottom: RegularSize.s,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.s,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: RegularColor.disable,
        ),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(RegularSize.m),
            child: Image.asset(
              avatar,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: RegularSize.m,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: RegularColor.dark,
                    ),
                  ),
                  Text(
                    job,
                    style: TextStyle(
                      fontSize: 12,
                      color: RegularColor.gray,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/building.svg',
                    width: RegularSize.m,
                    color: RegularColor.primary,
                  ),
                  SizedBox(width: RegularSize.xs),
                  Text(
                    company,
                    style: TextStyle(
                      fontSize: 13,
                      color: RegularColor.dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
