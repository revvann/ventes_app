// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/keyable_selectbar.dart';
import 'package:ventes/app/resources/widgets/regular_button.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/constants/formatters/range_number_formatter.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/app/resources/widgets/icon_button.dart' as custom_ib;

part 'package:ventes/app/resources/views/prospect_form/create/components/_twin_date_picker.dart';
part 'package:ventes/app/resources/views/prospect_form/create/components/_end_date_picker.dart';
part 'package:ventes/app/resources/views/prospect_form/create/components/_owner_dropdown.dart';
part 'package:ventes/app/resources/views/prospect_form/create/components/_customer_dropdown.dart';
part 'package:ventes/app/resources/views/prospect_form/create/components/_follow_up_selectbar.dart';
part 'package:ventes/app/resources/views/prospect_form/create/components/_product_list.dart';

class ProspectFormCreateView extends View<ProspectFormCreateStateController> {
  static const String route = "/prospect/create";

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
                        RegularInput(
                          label: "Name",
                          hintText: "Enter name",
                          controller: state.formSource.prosnameTEC,
                          validator: state.formSource.validator.prosname,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _TwinDatePicker(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _FollowUpSelectbar(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Value",
                          hintText: "Enter value",
                          inputType: TextInputType.number,
                          controller: state.formSource.prosvalueTEC,
                          validator: state.formSource.validator.prosvalue,
                          inputFormatters: [
                            state.formSource.prosvaluemask,
                          ],
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _EndDatePicker(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _OwnerDropdown(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        EditorInput(
                          label: "Description",
                          hintText: "Enter description",
                          controller: state.formSource.prosdescTEC,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        _CustomerDropdown(),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Products",
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
                        _ProductList(),
                        RegularButton(
                          label: "Add Product",
                          primary: RegularColor.green,
                          height: RegularSize.xl,
                          onPressed: state.listener.onAddProduct,
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
