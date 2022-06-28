// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:ventes/constants/regular_color.dart';

class MenuDivider extends StatelessWidget {
  String? text;
  MenuDivider({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Divider()),
        if (text != null) ...[
          SizedBox(
            width: 4,
          ),
          Text(
            text!,
            style: TextStyle(
              color: RegularColor.gray,
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: 4,
          ),
        ],
        Expanded(child: Divider()),
      ],
    );
  }
}
