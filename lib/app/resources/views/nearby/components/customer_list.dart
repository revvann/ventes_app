// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/nearby/nearby.dart';

class _CustomerList extends StatelessWidget {
  final NearbyStateController state = Get.find<Controller>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Customer> customers = state.dataSource.customers;
      return Expanded(
        child: customers.isEmpty
            ? Text(
                "There is no customer in your area",
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 16,
                ),
              )
            : ListView.separated(
                itemCount: customers.length,
                separatorBuilder: (_, index) {
                  return Divider();
                },
                itemBuilder: (_, index) {
                  Customer customer = customers[index];
                  String radius = (customer.radius! / 1000).toStringAsFixed(2);
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
                            child: Obx(() {
                              bool isSelected = state.property.selectedCustomer.any((c) => c.cstmid == customer.cstmid);
                              return SvgPicture.asset(
                                isSelected ? "assets/svg/marker.svg" : "assets/svg/building-bold.svg",
                                color: isSelected ? RegularColor.green : RegularColor.gray,
                                width: RegularSize.m,
                              );
                            }),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.cstmname ?? NearbyString.defaultCustomerName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: RegularSize.s,
                                ),
                                Text(
                                  customer.cstmaddress ?? NearbyString.defaultCustomerAddress,
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
                              "$radius KM",
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
