// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class MenuItem extends StatelessWidget {
  Function()? onTap;
  String title;
  String? icon;
  Color color;

  MenuItem({
    this.onTap,
    required this.title,
    this.icon,
    this.color = RegularColor.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RegularSize.s),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.1),
        hoverColor: color.withOpacity(0.1),
        focusColor: color.withOpacity(0.1),
        onTap: onTap ?? () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: RegularSize.s,
            horizontal: RegularSize.s,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                SvgPicture.asset(
                  icon!,
                  width: RegularSize.m,
                  color: color,
                ),
                SizedBox(width: RegularSize.s),
              ],
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
