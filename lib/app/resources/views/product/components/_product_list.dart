// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/product/product.dart';

class _ProductList extends StatelessWidget {
  ProductStateController state = Get.find<ProductStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.dataSource.products.length,
        itemBuilder: (_, index) {
          ProspectProduct product = state.dataSource.products[index];
          String amount = state.properties.priceShort(product.prosproductamount ?? 0);
          String price = currencyFormat(product.prosproductprice?.toString().replaceAll(RegExp(r'[.]'), ',') ?? "0");
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.m,
                horizontal: RegularSize.m,
              ),
              margin: EdgeInsets.only(
                bottom: RegularSize.m,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(RegularSize.m),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 30,
                    color: Color(0xFF0157E4).withOpacity(0.1),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          product.prosproductproduct?.productname ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: RegularColor.dark,
                          ),
                        ),
                      ),
                      SizedBox(width: RegularSize.s),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: RegularSize.s,
                          vertical: RegularSize.xs,
                        ),
                        decoration: BoxDecoration(
                          color: RegularColor.secondary,
                          borderRadius: BorderRadius.circular(RegularSize.s),
                        ),
                        child: Text(
                          amount,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: RegularSize.s),
                      PopupMenu(
                        controller: state.properties.createPopupController(index),
                        dropdownSettings: DropdownSettings(
                          width: 100,
                          offset: Offset(10, 5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: RegularSize.s,
                              horizontal: RegularSize.s,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MenuItem(
                                  title: "Edit",
                                  icon: "assets/svg/edit.svg",
                                  onTap: () {},
                                )
                              ],
                            ),
                          ),
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          padding: EdgeInsets.all(RegularSize.xs),
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: pi / 2,
                            child: SvgPicture.asset(
                              "assets/svg/menu-dots.svg",
                              color: RegularColor.dark,
                              width: RegularSize.m,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: RegularSize.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        price,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: RegularColor.dark,
                        ),
                      ),
                      Text(
                        " x${product.prosproductqty ?? 0}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: RegularColor.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
