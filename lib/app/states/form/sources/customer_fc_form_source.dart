import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/update_form_source.dart';

class CustomerFormCreateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final defaultPicture = Image.asset('assets/' + NearbyString.defaultImage).obs;

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController latitudeTEC = TextEditingController();
  TextEditingController longitudeTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();

  int? cstmid;
  File? picture;
  int? sbccstmstatusid;
  int? sbcbpid;
  int? provinceid;
  int? cityid;
  int? subdistrictid;

  final Rx<int?> _cstmtypeid = Rx<int?>(null);
  final Rx<String?> _cstmaddress = Rx<String?>(null);

  String get cstmlatitude => latitudeTEC.text;
  String get cstmlongitude => longitudeTEC.text;
  String get cstmname => nameTEC.text;
  String get cstmphone => phoneTEC.text;

  String? get cstmaddress => _cstmaddress.value;
  set cstmaddress(String? value) => _cstmaddress.value = value;

  int? get cstmtypeid => _cstmtypeid.value;

  set cstmtypeid(int? value) => _cstmtypeid.value = value;

  @override
  ready() async {
    super.ready();
    nameTEC.clear();
    phoneTEC.clear();
    latitudeTEC.clear();
    longitudeTEC.clear();

    picture = await _getImageFileFromAssets(NearbyString.defaultImage);

    latitudeTEC.text = property.latitude!.toString();
    longitudeTEC.text = property.longitude!.toString();
  }

  @override
  void close() {
    super.close();
    nameTEC.dispose();
    phoneTEC.dispose();
    latitudeTEC.dispose();
    longitudeTEC.dispose();
  }

  @override
  void prepareFormValues() async {
    nameTEC.text = dataSource.customer!.cstmname ?? "";
    cstmaddress = dataSource.customer!.cstmaddress ?? "";
    phoneTEC.text = dataSource.customer!.cstmphone ?? "";
    cstmtypeid = dataSource.customer!.cstmtypeid;
    provinceid = dataSource.customer!.cstmprovinceid;
    cityid = dataSource.customer!.cstmcityid;
    subdistrictid = dataSource.customer!.cstmsubdistrictid;
    cstmid = dataSource.customer!.cstmid;
    latitudeTEC.text = dataSource.customer!.cstmlatitude!.toString();
    longitudeTEC.text = dataSource.customer!.cstmlongitude!.toString();

    if (dataSource.customer?.cstmlatitude != null && dataSource.customer?.cstmlongitude != null) {
      LatLng latLng = LatLng(dataSource.customer!.cstmlatitude!, dataSource.customer!.cstmlongitude!);
      GoogleMapController controller = await property.mapsController.future;
      controller.moveCamera(CameraUpdate.newLatLng(latLng));
      property.markerLatLng = latLng;
    }
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> formData = {
      'sbccstmpic': picture?.path,
      'sbcbpid': sbcbpid.toString(),
      'sbccstmstatusid': sbccstmstatusid?.toString(),
      'cstmid': cstmid?.toString(),
      'cstmname': cstmname,
      'cstmaddress': cstmaddress ?? dataSource.getAddress(),
      'cstmphone': cstmphone,
      'cstmpostalcode': dataSource.getPostalCodeName(),
      'cstmprovinceid': provinceid.toString(),
      'cstmcityid': cityid.toString(),
      'cstmsubdistrictid': subdistrictid.toString(),
      'cstmtypeid': cstmtypeid?.toString(),
      'cstmlatitude': cstmlatitude,
      'cstmlongitude': cstmlongitude,
    };

    return formData;
  }

  @override
  void onSubmit() {
    Map<String, dynamic> data = toJson();
    String filename = path.basename(data['sbccstmpic']);
    data['sbccstmpic'] = MultipartFile(File(data['sbccstmpic']), filename: filename);

    FormData formData = FormData(data);
    dataSource.createHandler.fetcher.run(formData);
  }
}
