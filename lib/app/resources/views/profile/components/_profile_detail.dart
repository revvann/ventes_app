part of 'package:ventes/app/resources/views/profile/profile.dart';

class _ProfileDetail extends StatelessWidget {
  ProfileStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileItem(
            title: "Full Name",
            value: state.dataSource.userDetail?.user?.userfullname ?? "",
          ),
          SizedBox(height: RegularSize.m),
          _ProfileItem(
            title: "Email",
            value: state.dataSource.userDetail?.user?.useremail ?? "",
          ),
          SizedBox(height: RegularSize.m),
          _ProfileItem(
            title: "Phone",
            value: state.dataSource.userDetail?.user?.userphone ?? "",
          ),
        ],
      );
    });
  }
}
