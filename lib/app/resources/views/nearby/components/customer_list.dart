// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/nearby/nearby.dart';

class _CustomerList extends StatelessWidget {
  final NearbyStateController state = Get.find<NearbyStateController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<BpCustomer> customers = state.properties.dataSource.customers;
      return Expanded(
        child: ListView.separated(
          itemCount: customers.length,
          separatorBuilder: (_, index) {
            return Divider();
          },
          itemBuilder: (_, index) {
            BpCustomer customer = customers[index];
            String radius = (customer.radius! / 10).toStringAsFixed(2);
            return GestureDetector(
              onTap: () {
                state.listener.onCustomerSelected(customer);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: RegularSize.m,
                  right: RegularSize.m,
                  bottom: RegularSize.xs,
                  top: RegularSize.xs,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: RegularSize.m,
                      ),
                      child: SvgPicture.asset(
                        "assets/svg/building-bold.svg",
                        color: RegularColor.gray,
                        width: RegularSize.m,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.sbccstmname ?? NearbyString.defaultCustomerName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: RegularSize.s,
                          ),
                          Text(
                            customer.sbccstmaddress ?? NearbyString.defaultCustomerAddress,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: RegularColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: RegularSize.m,
                        left: RegularSize.m,
                      ),
                      child: Text(
                        "$radius DAM",
                        style: TextStyle(fontSize: 14, color: RegularColor.gray),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
