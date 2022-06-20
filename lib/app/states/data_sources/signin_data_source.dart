import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/auth_contract.dart';
import 'package:ventes/app/api/contracts/update_contract.dart';
import 'package:ventes/app/api/presenters/auth_presenter.dart';

class SigninDataSource {
  AuthPresenter presenter = AuthPresenter();
  final _isLoading = Rx<bool>(false);

  bool get isLoading => _isLoading.value;

  set updateContract(UpdateContract contract) => presenter.updateContract = contract;
  set authContract(AuthContract contract) => presenter.authContract = contract;
  set isLoading(bool value) => _isLoading.value = value;

  void signin(Map<String, dynamic> credentials) {
    isLoading = true;
    presenter.signIn(credentials);
  }

  void attachDevice(int id, String deviceid) {
    presenter.attachDevice(id, deviceid);
  }
}
