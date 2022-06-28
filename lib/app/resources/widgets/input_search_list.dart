// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';

class InputSearchList<T, V> extends StatelessWidget {
  InputSearchList({
    required this.label,
    required this.hint,
    this.value,
    required this.onFilter,
    required this.onItemSelected,
    required this.itemBuilder,
    this.validator,
    required this.compare,
    required this.controller,
  }) {
    _searchList = SearchList<T, V>(
      onFilter: onFilter,
      itemBuilder: itemBuilder,
      onItemSelected: onItemSelected,
      compare: compare,
      controller: controller,
    );
  }

  String label;
  String hint;
  String? value;
  Future Function(String?) onFilter;
  Function(V?)? onItemSelected;
  Widget Function(T item, V? selectedItem) itemBuilder;
  String? Function(String?)? validator;
  bool Function(T item, V? selectedItem) compare;
  SearchListController<T, V> controller;

  late SearchList<T, V> _searchList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RegularInput(
        label: label,
        hintText: hint,
        enabled: false,
        value: value,
        validator: validator,
      ),
      onTap: () {
        _searchList.show();
      },
    );
  }
}
