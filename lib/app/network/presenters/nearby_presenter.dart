import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/gmaps_service.dart';

class NearbyPresenter {
  final _gmapsService = Get.find<GmapsService>();
  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  void getDetail(double latitude, double longitude) async {
    try {
      Response response = await _gmapsService.getDetail(latitude, longitude);
      if (response.statusCode == 200) {
        _fetchDataContract.onLoadSuccess(response.body);
      } else {
        _fetchDataContract.onLoadFailed(response.body['error_message']);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }
}
