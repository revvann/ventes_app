// ignore_for_file: prefer_const_constructors

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view.dart';

part 'package:ventes/app/resources/views/contact_form/create/components/_type_dropdown.dart';

class ContactPersonFormCreateView extends View<ContactPersonFormCreateStateController> {
  static const String route = "/contactperson/create";

  ContactPersonFormCreateView(int customerid) {
    state.properties.customerid = customerid;
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
                        _TypeDropdown(),
                        SizedBox(height: RegularSize.m),
                        RegularInput(
                          label: "Contact Value",
                          hintText: "Enter contact (e.g. email, phone, etc.)",
                          controller: state.formSource.valueTEC,
                          validator: state.formSource.validator.contactvalue,
                        ),
                        SizedBox(height: RegularSize.m),
                        SearchableDropdown<Contact>(
                          controller: state.formSource.contactDropdownController,
                          isMultiple: false,
                          child: RegularInput(
                            enabled: false,
                            label: "Phone Number",
                            hintText: "select phone number",
                          ),
                          onChange: state.listener.onContactChanged,
                          onCompare: state.listener.onContactCompared,
                          onItemFilter: state.listener.onContactFilter,
                          itemBuilder: (item, isSelected) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: RegularSize.s,
                                vertical: RegularSize.s,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(RegularSize.s),
                                color: isSelected ? RegularColor.green.withOpacity(0.3) : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.value.givenName ?? "",
                                        style: TextStyle(
                                          color: isSelected ? RegularColor.green : RegularColor.dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: RegularSize.xs),
                                      Text(
                                        item.value.phones?.first.value ?? "",
                                        style: TextStyle(
                                          color: isSelected ? RegularColor.green : RegularColor.dark,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isSelected)
                                    SvgPicture.asset(
                                      "assets/svg/check.svg",
                                      color: RegularColor.green,
                                      height: RegularSize.m,
                                      width: RegularSize.m,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
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
