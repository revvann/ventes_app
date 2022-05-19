// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class CustomerCard extends StatelessWidget {
  CustomerCard({
    Key? key,
    this.margin,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.image,
    this.title,
    this.type,
    this.radius,
  }) : super(key: key);
  EdgeInsets? margin;
  double width;
  double height;
  ImageProvider<Object> image;
  String? title;
  String? type;
  String? radius;

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
        // image: DecorationImage(
        //   image: image,
        //   fit: BoxFit.cover,
        // ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Color(0xFF0157E4).withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: RegularSize.m,
          ),
          SizedBox(
            width: 75,
            height: 75,
            child: Image(
              image: image,
            ),
          ),
          SizedBox(
            width: RegularSize.s,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title ?? "",
                    overflow: TextOverflow.ellipsis,
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
                        'assets/svg/marker.svg',
                        width: RegularSize.m,
                        color: RegularColor.primary,
                      ),
                      SizedBox(
                        width: RegularSize.xs,
                      ),
                      Text(
                        radius ?? "",
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
