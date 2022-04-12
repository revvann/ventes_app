part of "package:ventes/views/schedule_form/create/schedule_fc.dart";

class _GuestList extends StatelessWidget {
  _GuestList({
    required this.guests,
    this.onRemove,
  });
  List<UserDetail> guests;
  void Function(UserDetail item)? onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: guests.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        UserDetail item = guests[index];
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: RegularSize.s,
            horizontal: RegularSize.s,
          ),
          child: Row(
            children: [
              Expanded(
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
              ),
              GestureDetector(
                onTap: () {
                  if (onRemove != null) {
                    onRemove!.call(item);
                  }
                },
                child: SvgPicture.asset(
                  "assets/svg/close.svg",
                  color: RegularColor.dark,
                  height: RegularSize.s,
                  width: RegularSize.s,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
