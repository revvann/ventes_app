// ignore_for_file: prefer_const_constructors

part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _GuestDropdown extends StatelessWidget {
  _GuestDropdown({required this.guests, this.onChanged, this.dropdownKey});
  List<UserDetail> guests;
  void Function(UserDetail?)? onChanged;
  GlobalKey<DropdownSearchState>? dropdownKey;

  @override
  Widget build(BuildContext context) {
    return FieldDropdown<UserDetail>(
      dropdownKey: dropdownKey,
      label: ScheduleString.scheguestLabel,
      hintText: "Invite guest",
      items: guests,
      onChanged: onChanged,
      popupItemBuilder: _buildDropdownItem,
      itemAsString: (item) => "Invite Guest",
      filterFn: (item, filter) {
        if (item != null && filter != null) {
          return item.user?.username?.toLowerCase().contains(filter.toLowerCase()) ?? false;
        }
        return false;
      },
    );
  }

  Widget _buildDropdownItem(BuildContext context, UserDetail item, bool isSelected) {
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
              item.user?.username?.substring(0, 2) ?? "",
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
                item.user?.username ?? "",
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 16,
                ),
              ),
              Text(
                item.usertype?.typename ?? "",
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
