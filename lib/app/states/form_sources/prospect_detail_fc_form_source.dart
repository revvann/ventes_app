part of 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';

class _FormSource extends RegularFormSource {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.detailCreateTag);

  _Validator validator = _Validator();

  KeyableDropdownController<int, DBType> categoryDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.categoryDropdownTag,
  );

  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.detailTypeCode,
  );

  TextEditingController prosdtdescTEC = TextEditingController();

  final Rx<DBType?> _prosdtcategory = Rx<DBType?>(null);
  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);
  Prospect? prospect;
  final Rx<String?> _prosdtloc = Rx<String?>(null);
  double? prosdtlat;
  double? prosdtlong;

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdtcategory => _prosdtcategory.value;
  set prosdtcategory(DBType? value) => _prosdtcategory.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  String? get prosdtloc => _prosdtloc.value;
  set prosdtloc(String? value) => _prosdtloc.value = value;

  String? get dateString => date != null ? formatDate(date!) : null;

  @override
  init() async {
    super.init();
    date = DateTime.now();

    Position pos = await getCurrentPosition();
    prosdtlat = pos.latitude;
    prosdtlong = pos.longitude;
    prosdtloc = "https://maps.google.com?q=$prosdtlat,$prosdtlong";

    Marker marker = Marker(
      markerId: MarkerId("currentloc"),
      position: LatLng(prosdtlat ?? 0, prosdtlong ?? 0),
      infoWindow: InfoWindow(
        title: "Current position",
      ),
    );
    _properties.marker = {marker};

    _properties.mapsController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(prosdtlat ?? 0, prosdtlong ?? 0)),
      );
    });
  }

  @override
  void close() {
    super.close();
    prosdtdescTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.categoryDropdownTag,
    );
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeCode,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectdtprospectid': prospect?.prospectid?.toString(),
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdtcatid': prosdtcategory?.typeid.toString(),
      'prospectdttypeid': prosdttype?.typeid.toString(),
      'prospectdtloc': prosdtloc,
      'prospectdtlatitude': prosdtlat.toString(),
      'prospectdtlongitude': prosdtlong.toString(),
    };
  }
}
