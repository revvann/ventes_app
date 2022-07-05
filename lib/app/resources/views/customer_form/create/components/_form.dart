// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';

class _CustomerForm extends StatelessWidget {
  _CustomerForm({Key? key}) : super(key: key);

  CustomerFormCreateStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formSource.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomerPicture(),
          SizedBox(
            height: RegularSize.m,
          ),
          RegularInput(
            label: "Customer name",
            hintText: "Enter name",
            controller: state.formSource.nameTEC,
            validator: state.formSource.validator.cstmname,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          RegularInput(
            label: "Customer phone",
            hintText: "Enter phone",
            controller: state.formSource.phoneTEC,
            inputType: TextInputType.number,
            validator: state.formSource.validator.cstmphone,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return RegularInput(
              label: "Customer postal code",
              value: state.dataSource.getPostalCodeName() ?? state.dataSource.customer?.cstmpostalcode,
              enabled: false,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return EditorInput(
              label: "Customer address",
              value: state.formSource.cstmaddress ?? state.dataSource.getAddress(),
              enabled: false,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return RegularInput(
              label: "Customer province",
              value: state.dataSource.getProvinceName() ?? state.dataSource.customer?.cstmprovince?.provname,
              enabled: false,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return RegularInput(
              label: "Customer city",
              value: state.dataSource.getCityName() ?? state.dataSource.customer?.cstmcity?.cityname,
              enabled: false,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return RegularInput(
              label: "Customer subdistrict",
              value: state.dataSource.getSubdistrictName() ?? state.dataSource.customer?.cstmsubdistrict?.subdistrictname,
              enabled: false,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return RegularInput(
              label: "Customer village",
              value: state.dataSource.getVillageName() ?? state.dataSource.customer?.cstmuv?.villagename,
              enabled: false,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return KeyableSelectBox<int>(
              label: "Customer type",
              onSelected: state.listener.onTypeSelected,
              activeIndex: state.formSource.cstmtypeid,
              items: state.dataSource.types,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return KeyableSelectBox<int>(
              label: "Customer status",
              onSelected: state.listener.onStatusSelected,
              items: state.dataSource.statuses,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          _PlacePicker(),
          SizedBox(
            height: RegularSize.l,
          ),
        ],
      ),
    );
  }
}
