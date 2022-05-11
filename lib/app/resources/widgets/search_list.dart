// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'dart:async';

class SearchList<T> {
  SearchList({
    required this.onFilter,
    required this.itemBuilder,
    this.onItemSelected,
  });
  Widget Function(T) itemBuilder;
  Future Function(String?) onFilter;
  void Function(T)? onItemSelected;

  show() {
    RegularBottomSheet(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: Get.height * 0.5,
        width: Get.width,
        child: _SearchList<T>(
          itemBuilder: itemBuilder,
          onFilter: onFilter,
          onItemSelected: onItemSelected,
        ),
      ),
    ).show();
  }
}

class _SearchList<T> extends StatefulWidget {
  _SearchList({
    required this.onFilter,
    required this.itemBuilder,
    this.onItemSelected,
  });

  Widget Function(T) itemBuilder;
  Future Function(String?) onFilter;
  void Function(T)? onItemSelected;

  @override
  State<_SearchList> createState() => __SearchListState<T>();
}

class __SearchListState<T> extends State<_SearchList<T>> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<T> _items = [];

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _rebuildList(query);
    });
  }

  _rebuildList(String? search) async {
    List<T> items = await widget.onFilter(search);
    setState(() {
      _items = items;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _rebuildList(null);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconInput(
          icon: "assets/svg/search.svg",
          hintText: "Search",
          controller: _searchController,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        if (_items.isEmpty)
          Text(
            "Item not found",
            style: TextStyle(
              color: RegularColor.dark,
              fontSize: 16,
            ),
          ),
        Expanded(
            child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (__, index) {
            T item = _items[index];
            return GestureDetector(
              child: widget.itemBuilder(item),
              onTap: () {
                widget.onItemSelected?.call(item);
              },
            );
          },
        )),
      ],
    );
  }
}
