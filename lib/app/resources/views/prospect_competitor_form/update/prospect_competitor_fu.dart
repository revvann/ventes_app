// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/api/models/files_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/regular_button.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view/view.dart';

part 'package:ventes/app/resources/views/prospect_competitor_form/update/components/_image_viewer.dart';

class ProspectCompetitorFormUpdateView extends View<Controller> {
  static const String route = "/prospectcompetitor/update";
  int competitorid;

  ProspectCompetitorFormUpdateView(this.competitorid);

  @override
  void onBuild(state) {
    state.property.competitorid = competitorid;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
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
          onRefresh: () async => state.refreshStates(),
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
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: state.formSource.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Prospect Competitor",
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
                        Obx(() {
                          return RegularInput(
                            label: "Prospect",
                            value: state.dataSource.prospect?.prospectname ?? "",
                          );
                        }),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Name",
                          hintText: "Enter name",
                          validator: state.formSource.validator.comptname,
                          controller: state.formSource.comptnameTEC,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Product name",
                          hintText: "Enter product name",
                          validator: state.formSource.validator.comptproductname,
                          controller: state.formSource.comptproductnameTEC,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        EditorInput(
                          label: "Description",
                          hintText: "Enter description",
                          controller: state.formSource.descriptionTEC,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Text(
                          "Images",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: RegularColor.primary,
                          ),
                        ),
                        RegularButton(
                          label: "Cohose Images",
                          primary: RegularColor.green,
                          height: RegularSize.xl,
                          onPressed: state.listener.pickImage,
                        ),
                        _ImageViewer(),
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
