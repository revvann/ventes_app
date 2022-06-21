// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/product/product.dart';

class _ProductList extends StatelessWidget {
  ProductStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.dataSource.products.length,
        itemBuilder: (_, index) {
          ProspectProduct product = state.dataSource.products[index];
          String amount = state.property.priceShort(product.prosproductamount ?? 0);
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
                        controller: state.property.createPopupController(index),
                        dropdownSettings: DropdownSettings(
                          width: 100,
                          offset: Offset(10, 5),
                          builder: (controller) => Padding(
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
                                  onTap: () => state.listener.navigateToFormEdit(product.prosproductid!),
                                ),
                                MenuItem(
                                  title: "Delete",
                                  icon: "assets/svg/delete.svg",
                                  onTap: () => state.listener.deleteProduct(product.prosproductid!),
                                ),
                                MenuItem(
                                  title: "Detail",
                                  icon: "assets/svg/detail.svg",
                                  onTap: () => showProductDetail(product),
                                ),
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

  void showProductDetail(ProspectProduct product) {
    String price = currencyFormat(product.prosproductprice?.toString().replaceAll(RegExp(r'[.]'), ',') ?? "0");
    RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.prosproductproduct?.productname ?? "",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: RegularColor.dark,
              ),
            ),
            SizedBox(
              height: RegularSize.xs,
            ),
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
            SizedBox(
              height: RegularSize.m,
            ),
            _DetailItem(title: "Amount", value: currencyFormat(product.prosproductamount?.toString().replaceAll('.', ',') ?? "0")),
            SizedBox(
              height: RegularSize.m,
            ),
            _DetailItem(title: "Discount", value: "${product.prosproductdiscount ?? 0} %".replaceAll('.', ',')),
            SizedBox(
              height: RegularSize.m,
            ),
            _DetailItem(title: "Tax Type", value: product.prosproducttaxtype?.typename ?? "No Tax"),
            SizedBox(
              height: RegularSize.m,
            ),
            _DetailItem(title: "Tax Total", value: currencyFormat(product.prosproducttax?.toString().replaceAll(RegExp(r'[.]'), ',') ?? "0")),
          ],
        ),
      ),
    ).show();
  }
}

class _DetailItem extends StatelessWidget {
  String title;
  String value;
  Color color;

  _DetailItem({
    required this.title,
    required this.value,
    this.color = RegularColor.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
