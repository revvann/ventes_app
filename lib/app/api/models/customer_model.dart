import 'package:ventes/app/api/models/city_model.dart';
import 'package:ventes/app/api/models/country_model.dart';
import 'package:ventes/app/api/models/province_model.dart';
import 'package:ventes/app/api/models/subdistrict_model.dart';
import 'package:ventes/app/api/models/village_model.dart';
import 'package:ventes/core/api/model.dart';
import 'package:ventes/app/api/models/type_model.dart';

class Customer extends Model {
  int? cstmid;
  String? cstmprefix;
  String? cstmname;
  String? cstmphone;
  String? cstmaddress;
  int? cstmtypeid;
  int? cstmprovinceid;
  int? cstmcityid;
  int? cstmsubdistrictid;
  int? cstmuvid;
  String? cstmpostalcode;
  double? cstmlatitude;
  double? cstmlongitude;
  String? referalcode;
  DBType? cstmtype;
  Province? cstmprovince;
  City? cstmcity;
  Subdistrict? cstmsubdistrict;
  Village? cstmuv;
  double? radius;

  Customer({
    this.cstmid,
    this.cstmprefix,
    this.cstmname,
    this.cstmphone,
    this.cstmaddress,
    this.cstmtypeid,
    this.cstmprovinceid,
    this.cstmcityid,
    this.cstmsubdistrictid,
    this.cstmuvid,
    this.cstmpostalcode,
    this.cstmlatitude,
    this.cstmlongitude,
    this.referalcode,
    this.cstmtype,
    this.cstmprovince,
    this.cstmcity,
    this.cstmsubdistrict,
    this.cstmuv,
    this.radius,
    String? createddate,
    String? updateddate,
    int? createdby,
    int? updatedby,
    bool? isactive,
  }) : super(
          createddate: createddate,
          createdby: createdby,
          updateddate: updateddate,
          updatedby: updatedby,
          isactive: isactive,
        );

  Customer.fromJson(Map<String, dynamic> json) {
    cstmid = json['cstmid'];
    cstmprefix = json['cstmprefix'];
    cstmname = json['cstmname'];
    cstmphone = json['cstmphone'];
    cstmaddress = json['cstmaddress'];
    cstmtypeid = json['cstmtypeid'];
    cstmprovinceid = json['cstmprovinceid'];
    cstmcityid = json['cstmcityid'];
    cstmsubdistrictid = json['cstmsubdistrictid'];
    cstmuvid = json['cstmuvid'];
    cstmpostalcode = json['cstmpostalcode'];
    referalcode = json['referalcode'];

    if (json['cstmlatitude'] != null && json['cstmlatitude'] is String) {
      cstmlatitude = double.parse(json['cstmlatitude']);
    } else {
      cstmlatitude = json['cstmlatitude'];
    }
    if (json['cstmlongitude'] != null && json['cstmlongitude'] is String) {
      cstmlongitude = double.parse(json['cstmlongitude']);
    } else {
      cstmlongitude = json['cstmlongitude'];
    }

    if (json['cstmtype'] != null) {
      cstmtype = DBType.fromJson(json['cstmtype']);
    }

    if (json['cstmprovince'] != null) {
      cstmprovince = Province.fromJson(json['cstmprovince']);
    }

    if (json['cstmcity'] != null) {
      cstmcity = City.fromJson(json['cstmcity']);
    }

    if (json['cstmsubdistrict'] != null) {
      cstmsubdistrict = Subdistrict.fromJson(json['cstmsubdistrict']);
    }

    if (json['cstmuv'] != null) {
      cstmuv = Village.fromJson(json['cstmuv']);
    }
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['cstmid'] = cstmid;
    data['cstmprefix'] = cstmprefix;
    data['cstmname'] = cstmname;
    data['cstmphone'] = cstmphone;
    data['cstmaddress'] = cstmaddress;
    data['cstmtypeid'] = cstmtypeid;
    data['cstmprovinceid'] = cstmprovinceid;
    data['cstmcityid'] = cstmcityid;
    data['cstmsubdistrictid'] = cstmsubdistrictid;
    data['cstmuvid'] = cstmuvid;
    data['cstmpostalcode'] = cstmpostalcode;
    data['cstmlatitude'] = cstmlatitude;
    data['cstmlongitude'] = cstmlongitude;
    data['referalcode'] = referalcode;

    if (cstmtype != null) {
      data['cstmtype'] = cstmtype!.toJson();
    }

    if (cstmprovince != null) {
      data['cstmprovince'] = cstmprovince!.toJson();
    }

    if (cstmcity != null) {
      data['cstmcity'] = cstmcity!.toJson();
    }

    if (cstmsubdistrict != null) {
      data['cstmsubdistrict'] = cstmsubdistrict!.toJson();
    }

    if (cstmuv != null) {
      data['cstmuv'] = cstmuv!.toJson();
    }
    return data;
  }
}
