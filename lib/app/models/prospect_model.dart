import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/core/model.dart';

class Prospect extends Model {
  int? prospectid;
  String? prospectname;
  String? prospectstartdate;
  String? prospectenddate;
  double? prospectvalue;
  int? prospectowner;
  int? prospectstageid;
  int? prospectstatusid;
  int? prospecttypeid;
  String? prospectexpclosedate;
  int? prospectbpid;
  String? prospectdescription;
  int? prospectcustid;
  int? prospectrefid;
  UserDetail? prospectowneruser;
  DBType? prospectstage;
  DBType? prospectstatus;
  DBType? prospecttype;
  BpCustomer? prospectcust;

  Prospect({
    this.prospectid,
    this.prospectname,
    this.prospectstartdate,
    this.prospectenddate,
    this.prospectvalue,
    this.prospectowner,
    this.prospectstageid,
    this.prospectstatusid,
    this.prospecttypeid,
    this.prospectexpclosedate,
    this.prospectbpid,
    this.prospectdescription,
    this.prospectcustid,
    this.prospectrefid,
    this.prospectowneruser,
    this.prospectstage,
    this.prospectstatus,
    this.prospecttype,
    this.prospectcust,
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

  Prospect.fromJson(Map<String, dynamic> json) {
    prospectid = json['prospectid'];
    prospectname = json['prospectname'];
    prospectstartdate = json['prospectstartdate'];
    prospectenddate = json['prospectenddate'];
    prospectvalue = json['prospectvalue'] is String ? double.tryParse(json['prospectvalue']) : json['prospectvalue'];
    prospectowner = json['prospectowner'];
    prospectstageid = json['prospectstageid'];
    prospectstatusid = json['prospectstatusid'];
    prospecttypeid = json['prospecttypeid'];
    prospectexpclosedate = json['prospectexpclosedate'];
    prospectbpid = json['prospectbpid'];
    prospectdescription = json['prospectdescription'];
    prospectcustid = json['prospectcustid'];
    prospectrefid = json['prospectrefid'];

    if (json['prospectowneruser'] != null) {
      prospectowneruser = UserDetail.fromJson(json['prospectowneruser']);
    }

    if (json['prospectstage'] != null) {
      prospectstage = DBType.fromJson(json['prospectstage']);
    }

    if (json['prospectstatus'] != null) {
      prospectstatus = DBType.fromJson(json['prospectstatus']);
    }

    if (json['prospecttype'] != null) {
      prospecttype = DBType.fromJson(json['prospecttype']);
    }

    if (json['prospectcust'] != null) {
      prospectcust = BpCustomer.fromJson(json['prospectcust']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prospectid'] = prospectid;
    data['prospectname'] = prospectname;
    data['prospectstartdate'] = prospectstartdate;
    data['prospectenddate'] = prospectenddate;
    data['prospectvalue'] = prospectvalue;
    data['prospectowner'] = prospectowner;
    data['prospectstageid'] = prospectstageid;
    data['prospectstatusid'] = prospectstatusid;
    data['prospecttypeid'] = prospecttypeid;
    data['prospectexpclosedate'] = prospectexpclosedate;
    data['prospectbpid'] = prospectbpid;
    data['prospectdescription'] = prospectdescription;
    data['prospectcustid'] = prospectcustid;
    data['prospectrefid'] = prospectrefid;

    if (prospectowneruser != null) {
      data['prospectowneruser'] = prospectowneruser?.toJson();
    }

    if (prospectstage != null) {
      data['prospectstage'] = prospectstage?.toJson();
    }

    if (prospectstatus != null) {
      data['prospectstatus'] = prospectstatus?.toJson();
    }

    if (prospecttype != null) {
      data['prospecttype'] = prospecttype?.toJson();
    }

    if (prospectcust != null) {
      data['prospectcust'] = prospectcust?.toJson();
    }

    return data;
  }
}
