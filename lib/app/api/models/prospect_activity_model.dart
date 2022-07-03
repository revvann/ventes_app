import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class ProspectActivity extends Model {
  int? prospectactivityid;
  int? prospectactivityprospectid;
  int? prospectactivitycatid;
  int? prospectactivitytypeid;
  String? prospectactivitydate;
  String? prospectactivitydesc;
  double? prospectactivitylatitude;
  double? prospectactivitylongitude;
  String? prospectactivityloc;
  Prospect? prospectactivityprospect;
  DBType? prospectactivitycat;
  DBType? prospectactivitytype;

  ProspectActivity({
    this.prospectactivityid,
    this.prospectactivityprospectid,
    this.prospectactivitycatid,
    this.prospectactivitytypeid,
    this.prospectactivitydate,
    this.prospectactivitydesc,
    this.prospectactivitylatitude,
    this.prospectactivitylongitude,
    this.prospectactivityloc,
    this.prospectactivityprospect,
    this.prospectactivitycat,
    this.prospectactivitytype,
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

  ProspectActivity.fromJson(Map<String, dynamic> json) {
    prospectactivityid = json['prospectactivityid'];
    prospectactivityprospectid = json['prospectactivityprospectid'];
    prospectactivitycatid = json['prospectactivitycatid'];
    prospectactivitytypeid = json['prospectactivitytypeid'];
    prospectactivitydate = json['prospectactivitydate'];
    prospectactivitydesc = json['prospectactivitydesc'];
    prospectactivitylatitude = json['prospectactivitylatitude'];
    prospectactivitylongitude = json['prospectactivitylongitude'];
    prospectactivityloc = json['prospectactivityloc'];

    if (json['prospectactivityprospect'] != null) {
      prospectactivityprospect = Prospect.fromJson(json['prospectactivityprospect']);
    }

    if (json['prospectactivitycat'] != null) {
      prospectactivitycat = DBType.fromJson(json['prospectactivitycat']);
    }

    if (json['prospectactivitytype'] != null) {
      prospectactivitytype = DBType.fromJson(json['prospectactivitytype']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prospectactivityid'] = prospectactivityid;
    data['prospectactivityprospectid'] = prospectactivityprospectid;
    data['prospectactivitycatid'] = prospectactivitycatid;
    data['prospectactivitytypeid'] = prospectactivitytypeid;
    data['prospectactivitydate'] = prospectactivitydate;
    data['prospectactivitydesc'] = prospectactivitydesc;
    data['prospectactivitylatitude'] = prospectactivitylatitude;
    data['prospectactivitylongitude'] = prospectactivitylongitude;
    data['prospectactivityloc'] = prospectactivityloc;

    if (prospectactivityprospect != null) {
      data['prospectactivityprospect'] = prospectactivityprospect?.toJson();
    }

    if (prospectactivitycat != null) {
      data['prospectactivitycat'] = prospectactivitycat?.toJson();
    }

    if (prospectactivitytype != null) {
      data['prospectactivitytype'] = prospectactivitytype?.toJson();
    }

    return data;
  }
}
