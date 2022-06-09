// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

part of "package:ventes/app/resources/views/dashboard/dashboard.dart";

class _UserMenuItem extends StatelessWidget {
  UserDetail user;
  bool isActive;
  Function()? onTap;
  _UserMenuItem({
    required this.user,
    this.isActive = false,
    this.onTap,
  });

  String get initialName => getInitials(user.user?.userfullname ?? "");

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RegularSize.s),
        splashColor: RegularColor.green.withOpacity(0.1),
        highlightColor: RegularColor.green.withOpacity(0.1),
        hoverColor: RegularColor.green.withOpacity(0.1),
        focusColor: RegularColor.green.withOpacity(0.1),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: RegularSize.s,
            horizontal: RegularSize.s,
          ),
          child: Row(
            children: [
              Container(
                child: Container(
                  width: RegularSize.xl,
                  height: RegularSize.xl,
                  alignment: Alignment.center,
                  child: Text(
                    initialName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? RegularColor.primary : RegularColor.secondary,
                  ),
                ),
              ),
              SizedBox(
                width: RegularSize.s,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.businesspartner?.bpname ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: isActive ? RegularColor.green : RegularColor.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.usertype?.typename ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: RegularColor.gray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
