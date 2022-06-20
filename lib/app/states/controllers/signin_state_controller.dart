import 'package:get/get.dart';
import 'package:ventes/app/states/data_sources/signin_data_source.dart';
import 'package:ventes/app/states/form/sources/signin_form_source.dart';

class SigninStateController extends GetxController {
  SigninFormSource formSource = SigninFormSource();
  SigninDataSource dataSource = SigninDataSource();

  void formSubmit() {
    if (formSource.formValid) {
      Map<String, dynamic> credentials = formSource.toJson();
      dataSource.signin(credentials);
    }
  }

  @override
  onInit() {
    super.onInit();
    formSource.init();
  }

  @override
  dispose() {
    formSource.dispose();
    super.dispose();
  }
}
