// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/regular_checkbox.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/regular_select_box.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/network/contracts/create_contract.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/schedule_fc_state_controller.dart';
import 'package:ventes/state_sources/form_sources/schedule_fc_form_source.dart';

part 'package:ventes/app/resources/views/schedule_form/create/components/_addmember_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_allday_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_dateend_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_datestart_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_description_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_event_form.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_guest_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_guest_item.dart';
part "package:ventes/app/resources/views/schedule_form/create/components/_guest_list.dart";
part 'package:ventes/app/resources/views/schedule_form/create/components/_link_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_location_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_online_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_private_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_readonly_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_remind_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_reminder_form.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_scheduletype_selectbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_sharelink_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_starttime_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_task_form.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_timezone_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_title_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_toward_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_twintime_input.dart';

class ScheduleFormCreateView extends RegularView<ScheduleFormCreateStateController> implements CreateContract {
  static const String route = "/schedule/create";
  ScheduleFormCreateView() {
    $ = controller;
    $.dataSource.createContract = this;
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
        title: ScheduleString.appBarTitle,
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
            onTap: $.listener.onFormSubmit,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
                horizontal: RegularSize.m,
              ),
              child: Text(
                ScheduleString.formCreateSubmitButton,
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
                ScheduleString.formCreateTitle,
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
            key: $.formSource.formKey,
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
                _TitleInput(
                  controller: $.formSource.schenmTEC,
                  validator: $.formSource.validator.schenm,
                ),
                SizedBox(
                  height: RegularSize.m,
                ),
                _ScheduletypeSelectbox(
                  onSelected: (value) {
                    $.formSource.schetype = value + $.formSource.taskId;
                  },
                  activeIndex: $.formSource.schetype - $.formSource.taskId,
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
                            offstage: $.formSource.schetype != $.formSource.eventId,
                            child: _EventForm(),
                          ),
                          Offstage(
                            offstage: $.formSource.schetype != $.formSource.taskId,
                            child: _TaskForm($),
                          ),
                          Offstage(
                            offstage: $.formSource.schetype != $.formSource.reminderId,
                            child: _ReminderForm($),
                          ),
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
  void onCreateFailed(String message) {
    Get.close(1);
    FailedAlert(ScheduleString.createFailed).show();
  }

  @override
  void onCreateSuccess(String message) {
    Get.close(1);
    SuccessAlert(ScheduleString.createSuccess).show();
  }

  @override
  void onCreateError(String message) {
    Get.close(1);
    ErrorAlert(ScheduleString.createError).show();
  }
}
