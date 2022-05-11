// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';

class _SearchList<T> extends StatelessWidget {
  CustomerFormCreateStateController state = Get.find<CustomerFormCreateStateController>();

  _SearchList({
    required this.label,
    required this.hint,
    this.value,
    required this.onFilter,
    required this.onItemSelected,
    required this.itemBuilder,
  });

  String label;
  String hint;
  String? value;
  Future Function(String?) onFilter;
  Function(T)? onItemSelected;
  Widget Function(T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RegularInput(
        label: label,
        hintText: hint,
        enabled: false,
        value: value,
      ),
      onTap: () {
        SearchList<T>(
          onFilter: onFilter,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
        ).show();
      },
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
          Text(
            text,
            style: TextStyle(
              color: RegularColor.dark,
              fontSize: 16,
            ),
          ),
          if (isSelected)
            Expanded(
              child: Container(),
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
