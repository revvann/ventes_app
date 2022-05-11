// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';

class _CustomerForm extends StatelessWidget {
  _CustomerForm({Key? key}) : super(key: key);

  CustomerFormCreateStateController state = Get.find<CustomerFormCreateStateController>();

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
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          RegularInput(
            label: "Customer phone",
            hintText: "Enter phone",
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          RegularInput(
            label: "Customer postal code",
            hintText: "Enter postal code",
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          EditorInput(
            label: "Customer address",
            hintText: "Enter address",
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<Country>(
              hint: 'Country',
              itemBuilder: (Country country) {
                return Obx(() {
                  bool isSelected = state.formSource.country?.countryid == country.countryid;
                  return _SearchListItem(
                    isSelected: isSelected,
                    text: state.formSource.country?.countryname ?? "",
                  );
                });
              },
              label: 'Search country',
              onFilter: state.listener.onCountryFilter,
              onItemSelected: state.listener.onCountrySelected,
              value: state.formSource.country?.countryname,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<Province>(
              hint: 'Province',
              itemBuilder: (Province province) {
                return Obx(() {
                  bool isSelected = state.formSource.province?.provid == province.provid;
                  return _SearchListItem(
                    isSelected: isSelected,
                    text: state.formSource.province?.provname ?? "",
                  );
                });
              },
              label: 'Search province',
              onFilter: state.listener.onProvinceFilter,
              onItemSelected: state.listener.onProvinceSelected,
              value: state.formSource.province?.provname,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<City>(
              hint: 'City',
              itemBuilder: (City city) {
                return Obx(() {
                  bool isSelected = state.formSource.city?.cityid == city.cityid;
                  return _SearchListItem(
                    isSelected: isSelected,
                    text: state.formSource.city?.cityname ?? "",
                  );
                });
              },
              label: 'Search city',
              onFilter: state.listener.onCityFilter,
              onItemSelected: state.listener.onCitySelected,
              value: state.formSource.city?.cityname,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<Subdistrict>(
              hint: 'Subdistrict',
              itemBuilder: (Subdistrict subdistrict) {
                return Obx(() {
                  bool isSelected = state.formSource.subdistrict?.subdistrictid == subdistrict.subdistrictid;
                  return _SearchListItem(
                    isSelected: isSelected,
                    text: state.formSource.subdistrict?.subdistrictname ?? "",
                  );
                });
              },
              label: 'Search subdistrict',
              onFilter: state.listener.onSubdistrictFilter,
              onItemSelected: state.listener.onSubdistrictSelected,
              value: state.formSource.subdistrict?.subdistrictname,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          KeyableSelectBox<int>(
            label: "Customer type",
            onSelected: (value) {
              print(value);
            },
            activeIndex: 13,
            items: const {
              13: "Manufacture",
              23: "Distributor",
              33: "Retailer",
            },
          ),
          SizedBox(
            height: RegularSize.l,
          ),
        ],
      ),
    );
  }
}
