// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';

class _BottomSheet extends StatelessWidget {
  _BottomSheet({required this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      snap: true,
      snapSizes: [
        1.0,
      ],
      builder: (BuildContext context, myscrollController) {
        return _BottomSheetContainer(
          child: child,
          scrollController: myscrollController,
        );
      },
    );
  }
}

class _BottomSheetContainer extends StatelessWidget {
  _BottomSheetContainer({
    required this.child,
    required this.scrollController,
  });

  CustomerFormUpdateStateController state = Get.find<Controller>();
  Widget child;
  ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: state.property.bottomSheetKey,
      padding: EdgeInsets.only(
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
        controller: scrollController,
        child: SizedBox(
          child: Column(
            children: [
              Text(
                NearbyString.bottomSheetTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
