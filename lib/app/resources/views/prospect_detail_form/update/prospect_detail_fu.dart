// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view.dart';

part 'package:ventes/app/resources/views/prospect_detail_form/update/components/_category_dropdown.dart';
part 'package:ventes/app/resources/views/prospect_detail_form/update/components/_type_dropdown.dart';
part 'package:ventes/app/resources/views/prospect_detail_form/update/components/_date_picker.dart';

class ProspectDetailFormUpdateView extends View<ProspectDetailFormUpdateStateController> {
  static const String route = "/prospect/detail/update";

  ProspectDetailFormUpdateView(int prospectDetailId) {
    state.properties.prospectDetailId = prospectDetailId;
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
        title: ProspectString.appBarTitle,
        appBarKey: state.appBarKey,
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
          GestureDetector(
            onTap: state.listener.onSubmitButtonClicked,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
                horizontal: RegularSize.m,
              ),
              child: Text(
                ProspectString.submitButtonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ).build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: state.listener.onRefresh,
          child: Obx(
            () {
              return Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: state.minHeight,
                ),
                padding: EdgeInsets.only(
                  right: RegularSize.m,
                  left: RegularSize.m,
                  top: RegularSize.l,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(RegularSize.xl),
                    topRight: Radius.circular(RegularSize.xl),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: state.formSource.formKey,
                    child: Column(
                      children: [
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
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _CategoryDropdown(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _TypeDropdown(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _DatePicker(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        EditorInput(
                          label: "Description",
                          hintText: "Enter description",
                          validator: state.formSource.validator.prosdtdesc,
                          controller: state.formSource.prosdtdescTEC,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
