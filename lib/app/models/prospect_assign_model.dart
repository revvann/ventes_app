import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/core/model.dart';

class ProspectAssign extends Model {
  int? prospectassignid;
  int? prospectassignto;
  int? prospectreportto;
  int? prospectid;
  String? prospectassigndesc;
  UserDetail? prospectassign;
  UserDetail? prospectreport;
  Prospect? prospect;

  ProspectAssign({
    this.prospectassignid,
    this.prospectassignto,
    this.prospectreportto,
    this.prospectassigndesc,
    this.prospectassign,
    this.prospectreport,
    this.prospectid,
    this.prospect,
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

  ProspectAssign.fromJson(Map<String, dynamic> json) {
    prospectassignid = json['prospectassignid'];
    prospectassignto = json['prospectassignto'];
    prospectreportto = json['prospectreportto'];
    prospectassigndesc = json['prospectassigndesc'];
    prospectid = json['prospectid'];

    if (json['prospectassign'] != null) {
      prospectassign = UserDetail.fromJson(json['prospectassign']);
    }

    if (json['prospectreport'] != null) {
      prospectreport = UserDetail.fromJson(json['prospectreport']);
    }

    if (json['prospect'] != null) {
      prospect = Prospect.fromJson(json['prospect']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prospectassignid'] = prospectassignid;
    data['prospectassignto'] = prospectassignto;
    data['prospectreportto'] = prospectreportto;
    data['prospectassigndesc'] = prospectassigndesc;
    data['prospectid'] = prospectid;

    if (prospectassign != null) {
      data['prospectassign'] = prospectassign?.toJson();
    }

    if (prospectreport != null) {
      data['prospectreport'] = prospectreport?.toJson();
    }

    if (prospect != null) {
      data['prospect'] = prospect?.toJson();
    }

    return data;
  }
}
