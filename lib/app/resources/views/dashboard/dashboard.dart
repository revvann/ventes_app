// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/menu_divider.dart';
import 'package:ventes/app/resources/widgets/pop_up_item.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';
import 'package:ventes/constants/styles/behavior_style.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/app/resources/widgets/bottom_navigation.dart';
import 'package:ventes/app/resources/widgets/customer_card.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

part 'package:ventes/app/resources/views/dashboard/components/_menu_item.dart';
part 'package:ventes/app/resources/views/dashboard/components/_appbar.dart';
part 'package:ventes/app/resources/views/dashboard/components/_top_panel.dart';
part 'package:ventes/app/resources/views/dashboard/components/_user_menu_item.dart';

class DashboardView extends View<Controller> {
  static const route = "/dashboard";

  @override
  Widget buildWidget(BuildContext context, state) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => state.refreshStates(),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _AppBar(),
                            _TopPanel(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 125,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: RegularSize.m,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                _MenuItem(
                                  color: RegularColor.purple,
                                  icon: "assets/svg/marker.svg",
                                  text: "Nearby",
                                  onTap: () => state.bottomNavigation.currentIndex = Views.nearby,
                                ),
                                SizedBox(
                                  width: RegularSize.s,
                                ),
                                _MenuItem(
                                  color: RegularColor.yellow,
                                  icon: "assets/svg/calendar.svg",
                                  text: "Schedule",
                                  onTap: () => state.bottomNavigation.currentIndex = Views.schedule,
                                ),
                                SizedBox(
                                  width: RegularSize.s,
                                ),
                                _MenuItem(
                                  color: RegularColor.cyan,
                                  icon: "assets/svg/attendance.svg",
                                  text: "Attendance",
                                  onTap: () async {
                                    Get.find<TaskHelper>().confirmPush(state.property.task.copyWith<bool>(
                                      message: "Are you sure you want to go to attendance?",
                                      onFinished: (result) {
                                        print(result);
                                      },
                                    ));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: RegularSize.s,
                            ),
                            Row(
                              children: [
                                _MenuItem(
                                  color: RegularColor.pink,
                                  icon: "assets/svg/daily-visit.svg",
                                  text: "Daily Visit",
                                  onTap: () {},
                                ),
                                SizedBox(
                                  width: RegularSize.s,
                                ),
                                _MenuItem(
                                  color: RegularColor.red,
                                  icon: "assets/svg/prospect.svg",
                                  text: "Prospect",
                                  onTap: () => state.bottomNavigation.currentIndex = Views.prospect,
                                ),
                                SizedBox(
                                  width: RegularSize.s,
                                ),
                                _MenuItem(
                                  color: RegularColor.gray,
                                  icon: "assets/svg/user.svg",
                                  text: "Profile",
                                  onTap: () => state.bottomNavigation.currentIndex = Views.profile,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: RegularSize.m,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: RegularSize.l,
                            ),
                            Text(
                              "Plan For You",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: RegularColor.primary,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: RegularSize.m,
                            ),
                            _buildTitleHeader("Nearby Customers"),
                          ],
                        ),
                      ),
                      Obx(() {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.dataSource.customers.isNotEmpty) ...[
                              SizedBox(
                                height: 148,
                                child: Obx(() {
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: state.dataSource.customers.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      BpCustomer customer = state.dataSource.customers[index];
                                      double mRight = 0;
                                      if (index == 9) {
                                        mRight = 16;
                                      }
                                      return CustomerCard(
                                        image: NetworkImage(customer.sbccstmpic ?? ""),
                                        margin: EdgeInsets.only(
                                          left: 16,
                                          right: mRight,
                                          top: 24,
                                          bottom: 24,
                                        ),
                                        width: 250,
                                        title: customer.sbccstmname,
                                        type: customer.sbccstm?.cstmtype?.typename ?? "",
                                        radius: (customer.radius! / 1000).toStringAsFixed(2) + " KM",
                                      );
                                    },
                                  );
                                }),
                              ),
                            ] else ...[
                              SizedBox(
                                height: RegularSize.s,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                  horizontal: RegularSize.m,
                                ),
                                child: Text(
                                  "There is no customer in this area",
                                  style: TextStyle(
                                    color: RegularColor.dark,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
                      SizedBox(
                        height: RegularSize.xl,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: RegularColor.dark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "See All",
          style: TextStyle(
            color: RegularColor.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
