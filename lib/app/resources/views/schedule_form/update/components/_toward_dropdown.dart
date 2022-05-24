// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _TowardDropdown extends StatelessWidget {
  _TowardDropdown({
    required this.onFilter,
    required this.itemBuilder,
    this.onItemSelected,
    this.selected,
    required this.compare,
    required this.controller,
  });
  Future<List<UserDetail>> Function(String?) onFilter;
  void Function(UserDetail? user)? onItemSelected;
  Widget Function(UserDetail user, UserDetail? selected) itemBuilder;
  bool Function(UserDetail user, UserDetail? selected) compare;
  SearchListController<UserDetail, UserDetail> controller;
  String? selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconInput(
        icon: "assets/svg/user.svg",
        label: "Toward",
        hintText: "Search User",
        value: selected,
        enabled: false,
      ),
      onTap: () {
        SearchList<UserDetail, UserDetail>(
          onFilter: onFilter,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          compare: compare,
          controller: controller,
        );
      },
    );
  }
}
