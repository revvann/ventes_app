// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';

class _CustomerPicture extends StatelessWidget {
  CustomerFormCreateStateController state = Get.find<CustomerFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(() {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: RegularColor.gray,
                        width: 1,
                      ),
                    ),
                    child: state.formSource.defaultPicture.value,
                  );
                }),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: state.listener.onPicturePicked,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: RegularColor.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/svg/plus-bold.svg',
                        color: Colors.white,
                        width: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: RegularSize.s),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Customer picture",
            style: TextStyle(
              fontSize: 14,
              color: RegularColor.dark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ]);
  }
}
