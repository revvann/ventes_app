import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/core/model.dart';

class ProspectDetail extends Model {
  int? prospectdtid;
  int? prospectdtprospectid;
  int? prospectdtcatid;
  int? prospectdttypeid;
  String? prospectdtdate;
  String? prospectdtdesc;
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
