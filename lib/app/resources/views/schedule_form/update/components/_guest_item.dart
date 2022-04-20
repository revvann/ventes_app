// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _GuestListItem extends StatelessWidget {
  _GuestListItem({
    this.userDetail,
    this.guest,
    this.isSelected = false,
    this.removable = false,
    this.onRemove,
  });
  UserDetail? userDetail;
  ScheduleGuest? guest;
  bool isSelected;
  bool removable;
  void Function(dynamic)? onRemove;

  dynamic get item => userDetail ?? guest;
  dynamic get user {
    if (userDetail != null) {
      return userDetail!.user;
    } else if (guest != null) {
      return guest!.scheuser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.s,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              user?.userfullname?.substring(0, 2).toUpperCase() ?? "",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            decoration: BoxDecoration(
              color: isSelected ? RegularColor.primary : RegularColor.purple,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: RegularSize.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.userfullname ?? "",
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 16,
                ),
              ),
              Text(
                item.businesspartner?.bpname ?? "",
                style: TextStyle(
                  color: RegularColor.gray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (isSelected || removable)
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
          if (removable)
            GestureDetector(
              onTap: () => onRemove?.call(item),
              child: SvgPicture.asset(
                "assets/svg/close.svg",
                color: RegularColor.dark,
                height: RegularSize.m,
                width: RegularSize.m,
              ),
            ),
        ],
      ),
    );
  }
}
