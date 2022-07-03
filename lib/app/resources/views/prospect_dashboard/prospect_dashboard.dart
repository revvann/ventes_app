// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/handler_container.dart';
import 'package:ventes/app/resources/widgets/pop_up_item.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/typedefs/prospect_dashboard_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/utils/utils.dart';

part 'package:ventes/app/resources/views/prospect_dashboard/components/_customer_list.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_detail_item.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_detail_list.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_horizontal_stat_card.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_mini_stat_card.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_owner_list.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_stat_panel.dart';
part 'package:ventes/app/resources/views/prospect_dashboard/components/_app_bar_menu.dart';

class ProspectDashboardView extends View<Controller> {
  static const String route = "/prospectdashboard";
  int prospectid;

  ProspectDashboardView(this.prospectid);

  @override
  void onBuild(state) {
    state.property.prospectid = prospectid;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: "Prospect",
        appBarKey: state.appBarKey,
        onTitleTap: () async => state.refreshStates(),
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: state.listener.goBack,
        ),
        actions: [
          _AppBarMenu(),
          SizedBox(width: RegularSize.s),
        ],
      ).build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => state.refreshStates(),
          child: Container(
            padding: EdgeInsets.only(
              top: RegularSize.l,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(RegularSize.xl),
                topRight: Radius.circular(RegularSize.xl),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  right: RegularSize.m,
                  left: RegularSize.m,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatPanel(),
                    SizedBox(height: RegularSize.m),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Prospect Detail",
                        style: TextStyle(
                          color: RegularColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: RegularSize.m),
                    _DetailList(),
                    SizedBox(height: RegularSize.m),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Owner Detail",
                        style: TextStyle(
                          color: RegularColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: RegularSize.m),
                    _OwnerList(),
                    SizedBox(height: RegularSize.m),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Customer Detail",
                        style: TextStyle(
                          color: RegularColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: RegularSize.m),
                    _CustomerList(),
                    SizedBox(height: RegularSize.m),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.listener.navigateToProspectUpdateForm,
        backgroundColor: RegularColor.primary,
        child: SvgPicture.asset(
          'assets/svg/edit.svg',
          color: Colors.white,
          width: RegularSize.l,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
