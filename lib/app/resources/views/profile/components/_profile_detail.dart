part of 'package:ventes/app/resources/views/profile/profile.dart';

class _ProfileDetail extends StatelessWidget {
  ProfileStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(UserDetail?)>(
      handlers: [state.dataSource.userDetailHandler],
      builder: (userDetail) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileItem(
            title: "Full Name",
            value: userDetail?.user?.userfullname ?? "",
          ),
          SizedBox(height: RegularSize.m),
          _ProfileItem(
            title: "Email",
            value: userDetail?.user?.useremail ?? "",
          ),
          SizedBox(height: RegularSize.m),
          _ProfileItem(
            title: "Phone",
            value: userDetail?.user?.userphone ?? "",
          ),
        ],
      ),
    );
  }
}
