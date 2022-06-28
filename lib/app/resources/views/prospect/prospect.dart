// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/handler_container.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/prospect_card.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view/view.dart';

part 'package:ventes/app/resources/views/prospect/components/_prospect_list.dart';
part 'package:ventes/app/resources/views/prospect/components/_status_dropdown.dart';
part 'package:ventes/app/resources/views/prospect/components/_twin_datepicker.dart';

class ProspectView extends View<Controller> {
  static const String route = "/history";

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: ProspectString.appBarTitle,
        appBarKey: state.appBarKey,
        onTitleTap: () async => state.refreshStates(),
      ).build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => state.refreshStates(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Obx(
              () {
                return Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: state.minHeight,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(RegularSize.xl),
                      topRight: Radius.circular(RegularSize.xl),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: RegularSize.l,
                      ),
                      _TwinDatePicker(),
                      SizedBox(
                        height: RegularSize.m,
                      ),
                      _StatusDropdown(),
                      SizedBox(
                        height: RegularSize.m,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
                        child: IconInput(
                          icon: "assets/svg/search.svg",
                          hintText: "Search",
                          controller: state.formSource.searchTEC,
                        ),
                      ),
                      SizedBox(
                        height: RegularSize.m,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Prospect List",
                          style: TextStyle(
                            fontSize: 20,
                            color: RegularColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: RegularSize.m,
                      ),
                      _ProspectList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.listener.onAddButtonClicked,
        backgroundColor: RegularColor.primary,
        child: SvgPicture.asset(
          'assets/svg/plus.svg',
          color: Colors.white,
          width: RegularSize.l,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
