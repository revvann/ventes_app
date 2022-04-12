// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/contracts/create_contract.dart';
import 'package:ventes/contracts/fetch_data_contract.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/models/auth_model.dart';
import 'package:ventes/models/user_detail_model.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/schedule_fc_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/editor_input.dart';
import 'package:ventes/widgets/field_dropdown.dart';
import 'package:ventes/widgets/regular_bottom_sheet.dart';
import 'package:ventes/widgets/regular_button.dart';
import 'package:ventes/widgets/regular_checkbox.dart';
import 'package:ventes/widgets/regular_date_picker.dart';
import 'package:ventes/widgets/regular_dropdown.dart';
import 'package:ventes/widgets/regular_outlined_button.dart';
import 'package:ventes/widgets/regular_select_box.dart';
import 'package:ventes/widgets/icon_input.dart';
import 'package:ventes/widgets/regular_input.dart';
import 'package:ventes/widgets/top_navigation.dart';

part 'package:ventes/views/schedule_form/create/components/_allday_checkbox.dart';
part 'package:ventes/views/schedule_form/create/components/_dateend_input.dart';
part 'package:ventes/views/schedule_form/create/components/_datestart_input.dart';
part 'package:ventes/views/schedule_form/create/components/_description_input.dart';
part 'package:ventes/views/schedule_form/create/components/_guest_dropdown.dart';
part 'package:ventes/views/schedule_form/create/components/_link_input.dart';
part 'package:ventes/views/schedule_form/create/components/_location_input.dart';
part 'package:ventes/views/schedule_form/create/components/_online_checkbox.dart';
part 'package:ventes/views/schedule_form/create/components/_remind_input.dart';
part 'package:ventes/views/schedule_form/create/components/_scheduletype_selectbox.dart';
part 'package:ventes/views/schedule_form/create/components/_title_input.dart';
part 'package:ventes/views/schedule_form/create/components/_twintime_input.dart';
part 'package:ventes/views/schedule_form/create/components/_event_form.dart';
part "package:ventes/views/schedule_form/create/components/_guest_list.dart";
part 'package:ventes/views/schedule_form/create/components/_readonly_checkbox.dart';
part 'package:ventes/views/schedule_form/create/components/_sharelink_checkbox.dart';
part 'package:ventes/views/schedule_form/create/components/_addmember_checkbox.dart';

class ScheduleFormCreateView extends RegularView<ScheduleFormCreateStateController> implements FetchDataContract, CreateContract {
  static const String route = "/schedule/create";
  ScheduleFormCreateView() {
    $ = controller;
    $.presenter.fetchDataContract = this;
    $.presenter.createContract = this;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        height: 85,
        title: "Schedule",
        appBarKey: $.appBarKey,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Get.back(id: ScheduleNavigator.id);
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if ($.formKey.currentState?.validate() ?? false) {
                $.createSchedule();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
                horizontal: RegularSize.m,
              ),
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        below: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Form Create",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.m,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RegularSize.xl),
              topRight: Radius.circular(RegularSize.xl),
            ),
          ),
          child: Form(
            key: $.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: RegularSize.l,
                ),
                Text(
                  "General",
                  style: TextStyle(
                    color: RegularColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: RegularSize.m,
                ),
                _TitleInput(controller: $.titleTEC),
                SizedBox(
                  height: RegularSize.m,
                ),
                _ScheduletypeSelectbox(
                  onSelected: (value) {
                    $.formSource.scheduleType = value + $.formSource.eventId;
                  },
                  activeIndex: $.formSource.scheduleType - $.formSource.eventId,
                ),
                SizedBox(
                  height: RegularSize.l,
                ),
                Text(
                  "More Options",
                  style: TextStyle(
                    color: RegularColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          Offstage(
                            offstage: $.formSource.scheduleType != $.formSource.eventId,
                            child: _EventForm($),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) async {
    AuthModel? auth = await Get.find<AuthHelper>().get();
    if (auth != null) {
      data['users'] = data['users'].where((user) {
        bool isNotSelected = $.formSource.guestsSelected.where((element) => element.userdtid == user.userdtid).isEmpty;
        bool isNotMe = user.userdtid != auth.accountActive;
        return isNotMe && isNotSelected;
      }).toList();
      $.guests = List<UserDetail>.from(data['users']);
    }
  }

  @override
  void onCreateFailed(String message) {}

  @override
  void onCreateSuccess(String message) {}
}
