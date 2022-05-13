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
          RegularInput(
            label: "Customer postal code",
            hintText: "Enter postal code",
            controller: state.formSource.postalCodeTEC,
            validator: state.formSource.validator.cstmpostalcode,
          ),
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
            return _SearchList<Country, Country>(
              hint: 'Country',
              itemBuilder: (Country country, Country? selected) {
                bool isSelected = selected?.countryid == country.countryid;
                return _SearchListItem(
                  isSelected: isSelected,
                  text: country.countryname ?? "",
                );
              },
              label: 'Search country',
              onFilter: state.listener.onCountryFilter,
              onItemSelected: state.listener.onCountrySelected,
              value: state.formSource.country?.countryname,
              validator: state.formSource.validator.cstmcountry,
              compare: state.listener.onCountryCompared,
              controller: state.formSource.countrySearchListController,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<Province, Province>(
              hint: 'Province',
              itemBuilder: (Province province, Province? selected) {
                bool isSelected = selected?.provid == province.provid;
                return _SearchListItem(
                  isSelected: isSelected,
                  text: province.provname ?? "",
                );
              },
              label: 'Search province',
              onFilter: state.listener.onProvinceFilter,
              onItemSelected: state.listener.onProvinceSelected,
              value: state.formSource.province?.provname,
              validator: state.formSource.validator.cstmprovince,
              compare: state.listener.onProvinceCompared,
              controller: state.formSource.provinceSearchListController,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<City, City>(
              hint: 'City',
              itemBuilder: (City city, City? selected) {
                bool isSelected = selected?.cityid == city.cityid;
                return _SearchListItem(
                  isSelected: isSelected,
                  text: city.cityname ?? "",
                );
              },
              label: 'Search city',
              onFilter: state.listener.onCityFilter,
              onItemSelected: state.listener.onCitySelected,
              value: state.formSource.city?.cityname,
              validator: state.formSource.validator.cstmcity,
              compare: state.listener.onCityCompared,
              controller: state.formSource.citySearchListController,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return _SearchList<Subdistrict, Subdistrict>(
              hint: 'Subdistrict',
              itemBuilder: (Subdistrict subdistrict, Subdistrict? selected) {
                bool isSelected = selected?.subdistrictid == subdistrict.subdistrictid;
                return _SearchListItem(
                  isSelected: isSelected,
                  text: subdistrict.subdistrictname ?? "",
                );
              },
              label: 'Search subdistrict',
              onFilter: state.listener.onSubdistrictFilter,
              onItemSelected: state.listener.onSubdistrictSelected,
              value: state.formSource.subdistrict?.subdistrictname,
              validator: state.formSource.validator.cstmsubdistrict,
              compare: state.listener.onSubdistrictCompared,
              controller: state.formSource.subdistrictSearchListController,
            );
          }),
          SizedBox(
            height: RegularSize.m,
          ),
          Obx(() {
            return KeyableSelectBox<int>(
              label: "Customer type",
              onSelected: state.listener.onTypeSelected,
              activeIndex: 13,
              items: state.properties.dataSource.types,
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
