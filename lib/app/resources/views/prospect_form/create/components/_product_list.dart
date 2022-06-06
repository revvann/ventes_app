// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';

class _ProductList extends StatelessWidget {
  ProspectFormCreateStateController state = Get.find<ProspectFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.formSource.prosproducts.length,
        itemBuilder: (_, index) {
          Map<String, dynamic> prosproduct = state.formSource.prosproducts[index];
          void onTaxChange(taxItem) => prosproduct['taxType'].value = taxItem.value;

          return Container(
            margin: EdgeInsets.only(
              bottom: RegularSize.m,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RegularInput(
                  label: "Name",
                  hintText: "Enter product name",
                  controller: prosproduct['nameTEC'],
                  validator: state.formSource.validator.prosproductname,
                ),
                SizedBox(
                  height: RegularSize.m,
                ),
                Row(children: [
                  Expanded(
                    child: RegularInput(
                      label: "Price",
                      hintText: "Enter price",
                      controller: prosproduct['priceTEC'],
                      inputType: TextInputType.number,
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                      validator: state.formSource.validator.prosproductprice,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: RegularSize.s,
                  ),
                  Expanded(
                    child: RegularInput(
                      label: "Quantity",
                      controller: prosproduct['qtyTEC'],
                      inputType: TextInputType.number,
                      inputFormatters: [
                        RangeInputFormatter(
                          minNumber: 1,
                          defaultNumber: 1,
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  SizedBox(
                    width: RegularSize.s,
                  ),
                  Expanded(
                    child: RegularInput(
                      label: "Discount (%)",
                      controller: prosproduct['discTEC'],
                      inputType: TextInputType.number,
                      inputFormatters: [
                        RangeInputFormatter(
                          maxNumber: 100,
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ]),
                SizedBox(
                  height: RegularSize.m,
                ),
                Obx(() {
                  return KeyableDropdown<int, DBType>(
                    controller: prosproduct['taxDropdownController'],
                    nullable: false,
                    child: Obx(() {
                      return RegularInput(
                        enabled: false,
                        label: "Tax Type",
                        value: prosproduct['taxType'].value.typename,
                      );
                    }),
                    items: state.dataSource.taxItems,
                    onChange: onTaxChange,
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
                Row(
                  children: [
                    Expanded(
                      child: RegularInput(
                        label: "Tax",
                        hintText: "Enter tax",
                        controller: prosproduct['taxTEC'],
                        inputType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatter(),
                        ],
                        validator: state.formSource.validator.prosproducttax,
                      ),
                    ),
                    SizedBox(
                      width: RegularSize.s,
                    ),
                    custom_ib.IconButton(
                      onPressed: () {
                        state.listener.onRemoveProduct(prosproduct);
                      },
                      primary: RegularColor.red,
                      icon: "assets/svg/delete.svg",
                      height: RegularSize.xl,
                      width: RegularSize.xl,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
