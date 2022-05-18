import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/core/model.dart';
import 'package:ventes/app/models/type_model.dart';

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
  Country? cstmcountry;
  Province? cstmprovince;
  City? cstmcity;
  Subdistrict? cstmsubdistrict;
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
    this.cstmcountry,
    this.cstmprovince,
    this.cstmcity,
    this.cstmsubdistrict,
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
    cstmlatitude = double.tryParse(json['cstmlatitude']);
    cstmlongitude = double.tryParse(json['cstmlongitude']);
    referalcode = json['referalcode'];

    if (json['cstmtype'] != null) {
      cstmtype = DBType.fromJson(json['cstmtype']);
    }

    if (json['cstmcountry'] != null) {
      cstmcountry = Country.fromJson(json['cstmcountry']);
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

    if (cstmcountry != null) {
      data['cstmcountry'] = cstmcountry!.toJson();
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
    return data;
  }
}
