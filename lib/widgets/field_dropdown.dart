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
    this.onChanged,
    required this.items,
    required this.popupItemBuilder,
    this.itemAsString,
    this.filterFn,
    required this.dropdownKey,
  }) : super(key: key);
  String? label;
  String? hintText;
  List<T> items;
  Function(T? value)? onChanged;
  Widget Function(BuildContext, T, bool) popupItemBuilder;
  String Function(T? item)? itemAsString;
  bool Function(T? item, String? filter)? filterFn;
  GlobalKey<DropdownSearchState> dropdownKey;

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
          key: dropdownKey,
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
          onChanged: onChanged,
          showSearchBox: true,
          showAsSuffixIcons: true,
          popupItemBuilder: popupItemBuilder,
          itemAsString: itemAsString ?? (item) => item.toString(),
          filterFn: filterFn,
        ),
      ],
    );
  }
}
