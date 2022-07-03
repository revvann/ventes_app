// ignore_for_file: prefer_const_constructors

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view/view.dart';

part 'package:ventes/app/resources/views/contact_form/create/components/_type_dropdown.dart';
part 'package:ventes/app/resources/views/contact_form/create/components/_contact_dropdown.dart';

class ContactPersonFormCreateView extends View<Controller> {
  static const String route = "/contactperson/create";
  int customerid;

  ContactPersonFormCreateView(this.customerid);

  @override
  void onBuild(state) {
    state.property.customerid = customerid;
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
                      children: [
                        Obx(() {
                          return RegularInput(
                            label: "Customer",
                            value: state.dataSource.customer?.cstmname,
                            enabled: false,
                          );
                        }),
                        SizedBox(height: RegularSize.m),
                        RegularInput(
                          label: "Name",
                          hintText: "Enter name",
                          controller: state.formSource.nameTEC,
                          validator: state.formSource.validator.contactname,
                        ),
                        SizedBox(height: RegularSize.m),
                        _TypeDropdown(),
                        SizedBox(height: RegularSize.m),
                        Obx(() {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (state.formSource.isPhone) ...[
                                _ContactDropdown(),
                                SizedBox(height: RegularSize.xs),
                              ],
                              RegularInput(
                                label: state.formSource.isPhone ? "Or Create New" : "Contact Value",
                                hintText: "Enter contact (e.g. email, phone, etc.)",
                                controller: state.formSource.valueTEC,
                                validator: state.formSource.validator.contactvalue,
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: RegularSize.m),
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
