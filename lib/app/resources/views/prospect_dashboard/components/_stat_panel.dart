part of 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';

class _StatPanel extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Obx(() {
                return _HorizontalStatCard(
                  height: 75,
                  value: state.dataSource.products.length.toString(),
                  text: "Products",
                  icon: "assets/svg/product-list.svg",
                  color: RegularColor.red,
                );
              }),
              SizedBox(
                height: RegularSize.s,
              ),
              Obx(() {
                return _HorizontalStatCard(
                  height: 75,
                  value: state.dataSource.prospectActivitys.length.toString(),
                  text: "Activity",
                  icon: "assets/svg/activity-check.svg",
                  color: RegularColor.indigo,
                );
              }),
            ],
          ),
        ),
        SizedBox(width: RegularSize.s),
        Expanded(
          child: Column(
            children: [
              Obx(() {
                return _HorizontalStatCard(
                  height: 75,
                  value: state.dataSource.assignUsers.length.toString(),
                  text: "Assigned User",
                  icon: "assets/svg/user.svg",
                  color: RegularColor.cyan,
                );
              }),
              SizedBox(
                height: RegularSize.s,
              ),
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        height: 75,
                        value: state.dataSource.prospect?.prospectstatus?.typename ?? "-",
                        text: "Status",
                        color: RegularColor.green,
                      ),
                    ),
                    SizedBox(width: RegularSize.s),
                    Expanded(
                      child: _MiniStatCard(
                        height: 75,
                        value: state.dataSource.prospect?.prospectstage?.typename ?? "-",
                        text: "Stage",
                        color: RegularColor.yellow,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
