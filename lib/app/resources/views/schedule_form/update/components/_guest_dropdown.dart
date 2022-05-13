// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _GuestDropdown extends StatelessWidget {
  _GuestDropdown({
    required this.onFilter,
    required this.itemBuilder,
    this.onItemSelected,
    required this.compare,
    required this.controller,
  });
  Future<List<UserDetail>> Function(String?) onFilter;
  void Function(List<UserDetail>? user)? onItemSelected;
  Widget Function(UserDetail user, List<UserDetail>? selected) itemBuilder;
  bool Function(UserDetail user, List<UserDetail>? selected) compare;
  SearchListController<UserDetail, List<UserDetail>?> controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconInput(
        icon: "assets/svg/user.svg",
        label: "Guest",
        hintText: "Search Guest",
        enabled: false,
      ),
      onTap: () {
        SearchList<UserDetail, List<UserDetail>?>(
          onFilter: onFilter,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          compare: compare,
          controller: controller,
        ).show();
      },
    );
  }
}
