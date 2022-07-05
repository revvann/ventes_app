// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';

class _CustomerForm extends StatelessWidget {
  _CustomerForm({Key? key}) : super(key: key);

  CustomerFormUpdateStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.m,
      ),
      child: Form(
        key: state.formSource.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                value: state.dataSource.bpCustomer?.sbccstm?.cstmpostalcode,
                enabled: false,
              );
            }),
            SizedBox(
              height: RegularSize.m,
            ),
            EditorInput(
              label: "Customer address",
              hintText: "Enter address",
              controller: state.formSource.addressTEC,
              validator: state.formSource.validator.cstmaddress,
            ),
            SizedBox(
              height: RegularSize.m,
            ),
            Obx(() {
              return RegularInput(
                label: "Customer province",
                value: state.dataSource.bpCustomer?.sbccstm?.cstmprovince?.provname,
                enabled: false,
              );
            }),
            SizedBox(
              height: RegularSize.m,
            ),
            Obx(() {
              return RegularInput(
                label: "Customer city",
                value: state.dataSource.bpCustomer?.sbccstm?.cstmcity?.cityname,
                enabled: false,
              );
            }),
            SizedBox(
              height: RegularSize.m,
            ),
            Obx(() {
              return RegularInput(
                label: "Customer subdistrict",
                value: state.dataSource.bpCustomer?.sbccstm?.cstmsubdistrict?.subdistrictname,
                enabled: false,
              );
            }),
            SizedBox(
              height: RegularSize.m,
            ),
            Obx(() {
              return RegularInput(
                label: "Customer village",
                value: state.dataSource.bpCustomer?.sbccstm?.cstmuv?.villagename,
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
                activeIndex: state.dataSource.bpCustomer?.sbccstmstatusid,
              );
            }),
            SizedBox(
              height: RegularSize.m,
            ),
            SizedBox(
              height: RegularSize.l,
            ),
          ],
        ),
      ),
    );
  }
}
