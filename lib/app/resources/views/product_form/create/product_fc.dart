// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/typedefs/product_fc_typedef.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/constants/formatters/range_number_formatter.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view/view.dart';

class ProductFormCreateView extends View<Controller> {
  static const String route = "/product/create";
  int prospectid;

  ProductFormCreateView(this.prospectid);

  @override
  void onBuild(state) {
    state.property.prospectid = prospectid;
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
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create Product",
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
                          hintText: "Enter product name",
                          controller: state.formSource.nameTEC,
                          validator: state.formSource.validator.prosproductname,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Price",
                          hintText: "Enter price",
                          controller: state.formSource.priceTEC,
                          inputType: TextInputType.number,
                          inputFormatters: [
                            CurrencyInputFormatter(),
                          ],
                          validator: state.formSource.validator.prosproductprice,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Row(children: [
                          Expanded(
                            child: RegularInput(
                              label: "Tax (%)",
                              hintText: "Enter tax",
                              controller: state.formSource.taxTEC,
                              inputType: TextInputType.number,
                              inputFormatters: [
                                RangeInputFormatter(
                                  maxNumber: 100,
                                ),
                              ],
                              validator: state.formSource.validator.prosproducttax,
                            ),
                          ),
                          SizedBox(
                            width: RegularSize.s,
                          ),
                          Expanded(
                            child: RegularInput(
                              label: "Quantity",
                              controller: state.formSource.qtyTEC,
                              inputType: TextInputType.number,
                              inputFormatters: [
                                RangeInputFormatter(
                                  minNumber: 1,
                                  defaultNumber: 1,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: RegularSize.s,
                          ),
                          Expanded(
                            child: RegularInput(
                              label: "Discount (%)",
                              controller: state.formSource.discTEC,
                              inputType: TextInputType.number,
                              inputFormatters: [
                                RangeInputFormatter(
                                  maxNumber: 100,
                                ),
                              ],
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Obx(() {
                          return KeyableDropdown<int, DBType>(
                            controller: state.formSource.taxDropdownController,
                            nullable: false,
                            child: Obx(() {
                              return RegularInput(
                                enabled: false,
                                label: "Tax Type",
                                value: state.formSource.prosproducttax?.typename,
                              );
                            }),
                            items: state.dataSource.taxItems,
                            onChange: state.listener.onTaxChanged,
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
                                  children: [
                                    Text(
                                      item.value.typename ?? "",
                                      style: TextStyle(
                                        color: isSelected ? RegularColor.green : RegularColor.dark,
                                        fontSize: 14,
                                      ),
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
                          );
                        }),
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
