import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_detail_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_sources/prospect_detail_fu_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_detail_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormUpdateDataSource implements FetchDataContract, UpdateContract {
  ProspectDetailFormUpdateListener get _listener => Get.find<ProspectDetailFormUpdateListener>();
  ProspectDetailFormUpdateFormSource get _formSource => Get.find<ProspectDetailFormUpdateFormSource>();

  final ProspectDetailFormUpdatePresenter _presenter = ProspectDetailFormUpdatePresenter();

  final Rx<List<KeyableDropdownItem<int, DBType>>> _categoryItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set categoryItems(List<KeyableDropdownItem<int, DBType>> value) => _categoryItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get categoryItems => _categoryItems.value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _typeItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set typeItems(List<KeyableDropdownItem<int, DBType>> value) => _typeItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get typeItems => _typeItems.value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _taxItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set taxItems(List<KeyableDropdownItem<int, DBType>> value) => _taxItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get taxItems => _taxItems.value;

  final Rx<ProspectDetail?> _prospectdetail = Rx<ProspectDetail?>(null);
  set prospectdetail(ProspectDetail? value) => _prospectdetail.value = value;
  ProspectDetail? get prospectdetail => _prospectdetail.value;

  init() {
    _presenter.fetchDataContract = this;
    _presenter.updateContract = this;
  }

  void fetchData(int id) => _presenter.fetchData(id);
  void updateData(int id, Map<String, dynamic> data) => _presenter.updateData(id, data);

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['categories'] != null) {
      List<DBType> categories = data['categories'].map<DBType>((item) => DBType.fromJson(item)).toList();
      categoryItems = categories.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((item) => DBType.fromJson(item)).toList();
      typeItems = types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['prospectdetail'] != null) {
      prospectdetail = ProspectDetail.fromJson(data['prospectdetail']);
      _formSource.prepareValue(prospectdetail!);
    }
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateDetailTaskCode);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
