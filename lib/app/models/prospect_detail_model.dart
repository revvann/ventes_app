import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class ProspectDetail extends Model {
  int? prospectdtid;
  int? prospectdtprospectid;
  int? prospectdtcatid;
  int? prospectdttypeid;
  String? prospectdtdate;
  String? prospectdtdesc;
  double? prospectdtlatitude;
  double? prospectdtlongitude;
  String? prospectdtloc;
  Prospect? prospectdtprospect;
  DBType? prospectdtcat;
  DBType? prospectdttype;

  ProspectDetail({
    this.prospectdtid,
    this.prospectdtprospectid,
    this.prospectdtcatid,
    this.prospectdttypeid,
    this.prospectdtdate,
    this.prospectdtdesc,
    this.prospectdtlatitude,
    this.prospectdtlongitude,
    this.prospectdtloc,
    this.prospectdtprospect,
    this.prospectdtcat,
    this.prospectdttype,
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

  ProspectDetail.fromJson(Map<String, dynamic> json) {
    prospectdtid = json['prospectdtid'];
    prospectdtprospectid = json['prospectdtprospectid'];
    prospectdtcatid = json['prospectdtcatid'];
    prospectdttypeid = json['prospectdttypeid'];
    prospectdtdate = json['prospectdtdate'];
    prospectdtdesc = json['prospectdtdesc'];
    prospectdtlatitude = json['prospectdtlatitude'];
    prospectdtlongitude = json['prospectdtlongitude'];
    prospectdtloc = json['prospectdtloc'];

    if (json['prospectdtprospect'] != null) {
      prospectdtprospect = Prospect.fromJson(json['prospectdtprospect']);
    }

    if (json['prospectdtcat'] != null) {
      prospectdtcat = DBType.fromJson(json['prospectdtcat']);
    }

    if (json['prospectdttype'] != null) {
      prospectdttype = DBType.fromJson(json['prospectdttype']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prospectdtid'] = prospectdtid;
    data['prospectdtprospectid'] = prospectdtprospectid;
    data['prospectdtcatid'] = prospectdtcatid;
    data['prospectdttypeid'] = prospectdttypeid;
    data['prospectdtdate'] = prospectdtdate;
    data['prospectdtdesc'] = prospectdtdesc;
    data['prospectdtlatitude'] = prospectdtlatitude;
    data['prospectdtlongitude'] = prospectdtlongitude;
    data['prospectdtloc'] = prospectdtloc;

    if (prospectdtprospect != null) {
      data['prospectdtprospect'] = prospectdtprospect?.toJson();
    }

    if (prospectdtcat != null) {
      data['prospectdtcat'] = prospectdtcat?.toJson();
    }

    if (prospectdttype != null) {
      data['prospectdttype'] = prospectdttype?.toJson();
    }

    return data;
  }
}
