import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/core/model.dart';

class ProspectAssign extends Model {
  int? prospectassignid;
  int? prospectassignto;
  int? prospectreportto;
  String? prospectassingdesc;
  UserDetail? prospectassign;
  UserDetail? prospectreport;

  ProspectAssign({
    this.prospectassignid,
    this.prospectassignto,
    this.prospectreportto,
    this.prospectassingdesc,
    this.prospectassign,
    this.prospectreport,
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
    prospectassingdesc = json['prospectassingdesc'];

    if (json['prospectassign'] != null) {
      prospectassign = UserDetail.fromJson(json['prospectassign']);
    }

    if (json['prospectreport'] != null) {
      prospectreport = UserDetail.fromJson(json['prospectreport']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prospectassignid'] = prospectassignid;
    data['prospectassignto'] = prospectassignto;
    data['prospectreportto'] = prospectreportto;
    data['prospectassingdesc'] = prospectassingdesc;

    if (prospectassign != null) {
      data['prospectassign'] = prospectassign?.toJson();
    }

    if (prospectreport != null) {
      data['prospectreport'] = prospectreport?.toJson();
    }

    return data;
  }
}
