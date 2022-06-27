part of 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';

class _OwnerList extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(UserDetail?)>(
      handlers: [state.dataSource.userHandler],
      width: RegularSize.xl,
      builder: (user) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailItem(title: "Full Name", value: user?.user?.userfullname ?? "-"),
          SizedBox(height: RegularSize.s),
          _DetailItem(title: "Email", value: user?.user?.useremail ?? "-"),
          SizedBox(height: RegularSize.s),
          _DetailItem(title: "Phone", value: user?.user?.userphone ?? "-"),
        ],
      ),
    );
  }
}
