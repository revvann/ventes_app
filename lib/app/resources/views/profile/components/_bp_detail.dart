part of 'package:ventes/app/resources/views/profile/profile.dart';

class _BpDetail extends StatelessWidget {
  ProfileStateController state = Get.find<ProfileStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileItem(
            title: "Business Name",
            value: state.dataSource.userDetail?.businesspartner?.bpname ?? "-",
          ),
          SizedBox(height: RegularSize.m),
          _ProfileItem(
            title: "Business Email",
            value: state.dataSource.userDetail?.businesspartner?.bpemail ?? "-",
          ),
          SizedBox(height: RegularSize.m),
          _ProfileItem(
            title: "Business Phone",
            value: state.dataSource.userDetail?.businesspartner?.bpphone ?? "-",
          ),
          SizedBox(height: RegularSize.m),
          Text(
            "More",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
          Wrap(
            spacing: RegularSize.s,
            runSpacing: RegularSize.s,
            children: [
              if (state.dataSource.userDetail?.businesspartner?.bptype?.typename != null)
                _DetailTag(
                  text: state.dataSource.userDetail!.businesspartner!.bptype!.typename!,
                  color: RegularColor.pink,
                ),
              if (state.dataSource.userDetail?.usertype?.typename != null)
                _DetailTag(
                  text: state.dataSource.userDetail!.usertype!.typename!,
                  color: RegularColor.green,
                ),
            ],
          ),
        ],
      );
    });
  }
}

class _DetailTag extends StatelessWidget {
  String text;
  Color color;
  _DetailTag({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
    );
  }
}
