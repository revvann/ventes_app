// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _GuestDropdown extends StatelessWidget {
  _GuestDropdown({required this.onFilter, required this.itemBuilder, this.onItemSelected});
  Future<List<UserDetail>> Function(String?) onFilter;
  void Function(UserDetail user)? onItemSelected;
  Widget Function(UserDetail user) itemBuilder;

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
        SearchList<UserDetail>(
          onFilter: onFilter,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
        ).show();
      },
    );
  }
}
