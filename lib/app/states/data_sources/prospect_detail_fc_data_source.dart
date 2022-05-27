import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_detail_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_sources/prospect_detail_fc_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_detail_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormCreateDataSource implements FetchDataContract, CreateContract {
  ProspectDetailFormCreateListener get _listener => Get.find<ProspectDetailFormCreateListener>();
  ProspectDetailFormCreateFormSource get _formSource => Get.find<ProspectDetailFormCreateFormSource>();

  final ProspectDetailFormCreatePresenter _presenter = ProspectDetailFormCreatePresenter();

  final Rx<List<DropdownItem<int, DBType>>> _categoryItems = Rx<List<DropdownItem<int, DBType>>>([]);
  set categoryItems(List<DropdownItem<int, DBType>> value) => _categoryItems.value = value;
  List<DropdownItem<int, DBType>> get categoryItems => _categoryItems.value;

  final Rx<List<DropdownItem<int, DBType>>> _typeItems = Rx<List<DropdownItem<int, DBType>>>([]);
  set typeItems(List<DropdownItem<int, DBType>> value) => _typeItems.value = value;
  List<DropdownItem<int, DBType>> get typeItems => _typeItems.value;

  final Rx<Prospect?> _prospect = Rx<Prospect?>(null);
  set prospect(Prospect? value) => _prospect.value = value;
  Prospect? get prospect => _prospect.value;

  init() {
    _presenter.fetchDataContract = this;
    _presenter.createContract = this;
  }

  void fetchData(int id) => _presenter.fetchData(id);
  void createData(Map<String, dynamic> data) => _presenter.createData(data);

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['categories'] != null) {
      List<DBType> categories = data['categories'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosdtcategory = categories.isNotEmpty ? categories.first : null;
      categoryItems = categories.map<DropdownItem<int, DBType>>((item) => DropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosdttype = types.isNotEmpty ? types.first : null;
      typeItems = types.map<DropdownItem<int, DBType>>((item) => DropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
      _formSource.prospectid = prospect?.prospectid;
    }
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateDetailTaskCode);
  }

  @override
  void onCreateError(String message) => _listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => _listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => _listener.onCreateDataSuccess(message);
}
