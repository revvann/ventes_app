// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';

class _SearchList<T, V> extends StatelessWidget {
  CustomerFormCreateStateController state = Get.find<CustomerFormCreateStateController>();

  _SearchList({
    required this.label,
    required this.hint,
    this.value,
    required this.onFilter,
    required this.onItemSelected,
    required this.itemBuilder,
    this.validator,
    required this.compare,
    required this.controller,
  });

  String label;
  String hint;
  String? value;
  Future Function(String?) onFilter;
  Function(V?)? onItemSelected;
  Widget Function(T item, V? selectedItem) itemBuilder;
  String? Function(String?)? validator;
  bool Function(T item, V? selectedItem) compare;
  SearchListController<T, V> controller;

  @override
  Widget build(BuildContext context) {
    return InputSearchList<T, V>(
      onFilter: onFilter,
      itemBuilder: itemBuilder,
      onItemSelected: onItemSelected,
      compare: compare,
      label: label,
      hint: hint,
      value: value,
      validator: validator,
      controller: controller,
    );
  }
}

class _SearchListItem extends StatelessWidget {
  bool isSelected;
  String text;

  _SearchListItem({required this.isSelected, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.s,
      ),
      child: Row(
        children: [
          SizedBox(width: RegularSize.s),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: RegularColor.dark,
                fontSize: 16,
              ),
            ),
          ),
          if (isSelected)
            SvgPicture.asset(
              "assets/svg/check.svg",
              color: RegularColor.primary,
              height: RegularSize.m,
              width: RegularSize.m,
            ),
        ],
      ),
    );
  }
}
