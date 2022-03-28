// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class ScheduleCard extends StatelessWidget {
  ScheduleCard({Key? key, this.margin, this.width = double.infinity, this.height = double.infinity, required this.image, this.title, this.type, this.time, this.media, this.contact, this.department})
      : super(key: key);
  EdgeInsets? margin;
  double width;
  double height;
  ImageProvider<Object> image;
  String? title;
  String? type;
  String? time;
  String? media;
  String? contact;
  String? department;

  @override
  Widget build(BuildContext context) {
    double footerHeight = 100;
    if (department != null) footerHeight += 20;
    if (contact != null) footerHeight += 20;
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RegularSize.m),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Color(0xFF0157E4).withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(RegularSize.s),
              alignment: Alignment.topRight,
              child: Container(
                width: RegularSize.xl,
                height: RegularSize.xl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/svg/bookmark.svg',
                  color: RegularColor.secondary,
                  width: RegularSize.m,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: footerHeight,
            padding: EdgeInsets.symmetric(
              vertical: RegularSize.s,
              horizontal: RegularSize.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: RegularColor.dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  type ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: RegularColor.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/history.svg',
                      width: RegularSize.m,
                      color: RegularColor.primary,
                    ),
                    SizedBox(
                      width: RegularSize.xs,
                    ),
                    Text(
                      time ?? "",
                      style: TextStyle(
                        color: RegularColor.dark,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: RegularSize.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: RegularSize.s,
                        vertical: RegularSize.xs,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: RegularColor.primary,
                        borderRadius: BorderRadius.circular(RegularSize.m),
                      ),
                      child: Text(
                        media ?? "",
                        style: TextStyle(
                          color: RegularColor.dark,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                if (department != null)
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/department.svg',
                        width: RegularSize.m,
                        color: RegularColor.primary,
                      ),
                      SizedBox(
                        width: RegularSize.xs,
                      ),
                      Text(
                        department ?? "",
                        style: TextStyle(
                          color: RegularColor.dark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (contact != null)
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/user.svg',
                        width: RegularSize.m,
                        color: RegularColor.primary,
                      ),
                      SizedBox(
                        width: RegularSize.xs,
                      ),
                      Text(
                        contact ?? "",
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
        ],
      ),
    );
  }
}
