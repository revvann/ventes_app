import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/customer_fc_presenter.dart';
import 'package:get/get.dart';

class CustomerFormCreateDataSource {
  final CustomerFormCreatePresenter _presenter = CustomerFormCreatePresenter();

  set fetchDataContract(FetchDataContract value) => _presenter.fetchDataContract = value;
  set createContract(CreateContract value) => _presenter.createContract = value;

  final _customers = <BpCustomer>[].obs;
  set customers(List<BpCustomer> value) => _customers.value = value;
  List<BpCustomer> get customers => _customers.value;

  final _types = <int, String>{}.obs;
  set types(Map<int, String> value) => _types.value = value;
  Map<int, String> get types => _types.value;

  void customersFromList(List data) {
    customers = data.map((e) => BpCustomer.fromJson(e)).toList();
  }

  void typesFromList(List data) {
    Map<int, String> typesData = {};
    List<DBType> types = List<DBType>.from(data.map((e) => DBType.fromJson(e)));
    for (var type in types) {
      typesData[type.typeid ?? 0] = type.typename ?? '';
    }
    this.types = typesData;
  }

  Future<List<Country>> fetchCountries([String? search]) async => await _presenter.fetchCountries(search);
  Future<List<Province>> fetchProvinces(int countryId, [String? search]) async => await _presenter.fetchProvinces(countryId, search);
  Future<List<City>> fetchCities(int provinceId, [String? search]) async => await _presenter.fetchCities(provinceId, search);
  Future<List<Subdistrict>> fetchSubdistricts(int cityId, [String? search]) async => await _presenter.fetchSubdistricts(cityId, search);

  void fetchData() => _presenter.fetchData();
  void createCustomer(FormData data) => _presenter.createCustomer(data);
}
