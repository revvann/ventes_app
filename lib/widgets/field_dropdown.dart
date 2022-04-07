// ignore_for_file: prefer_const_constructors

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class FieldDropdown<T> extends StatelessWidget {
  FieldDropdown({
    Key? key,
    this.label,
    this.hintText,
    required this.items,
  }) : super(key: key);
  String? label;
  String? hintText;
  List<T> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? "",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: RegularColor.dark,
            ),
          ),
        DropdownSearch<T>(
          dropdownSearchDecoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.disable,
                width: 2,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.disable,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.primary,
                width: 2,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.red,
                width: 2,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: RegularColor.gray,
              fontSize: 16,
            ),
            constraints: BoxConstraints(maxHeight: 42),
          ),
          dropdownSearchBaseStyle: TextStyle(
            fontSize: 16,
            color: RegularColor.dark,
          ),
          mode: Mode.BOTTOM_SHEET,
          showSelectedItems: false,
          items: items,
          onChanged: print,
          showSearchBox: true,
          showAsSuffixIcons: true,
          popupItemBuilder: _buildDropdownItem,
        ),
      ],
    );
  }

  Widget _buildDropdownItem(BuildContext context, T item, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.s,
        horizontal: RegularSize.s,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(RegularSize.s),
            child: Text(
              "WK",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            decoration: BoxDecoration(
              color: RegularColor.purple,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: RegularSize.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.toString(),
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 16,
                ),
              ),
              Text(
                "Teknisi",
                style: TextStyle(
                  color: RegularColor.gray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
