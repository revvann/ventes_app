import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/core/api/model.dart';

class Prospect extends Model {
  int? prospectid;
  String? prospectname;
  String? prospectstartdate;
  String? prospectenddate;
  double? prospectvalue;
  int? prospectowner;
  int? prospectstageid;
  int? prospectstatusid;
  String? prospectexpclosedate;
  int? prospectbpid;
  String? prospectdescription;
  int? prospectcustid;
  int? prospectrefid;
  int? prospectlostreasonid;
  String? prospectlostdesc;
  UserDetail? prospectowneruser;
  DBType? prospectstage;
  DBType? prospectstatus;
  DBType? prospectlostreason;
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
    this.prospectexpclosedate,
    this.prospectbpid,
    this.prospectdescription,
    this.prospectcustid,
    this.prospectrefid,
    this.prospectowneruser,
    this.prospectstage,
    this.prospectstatus,
    this.prospectlostreason,
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
    prospectexpclosedate = json['prospectexpclosedate'];
    prospectbpid = json['prospectbpid'];
    prospectdescription = json['prospectdescription'];
    prospectcustid = json['prospectcustid'];
    prospectrefid = json['prospectrefid'];
    prospectlostreasonid = json['prospectlostreasonid'];
    prospectlostdesc = json['prospectlostdesc'];

    if (json['prospectowneruser'] != null) {
      prospectowneruser = UserDetail.fromJson(json['prospectowneruser']);
    }

    if (json['prospectstage'] != null) {
      prospectstage = DBType.fromJson(json['prospectstage']);
    }

    if (json['prospectstatus'] != null) {
      prospectstatus = DBType.fromJson(json['prospectstatus']);
    }

    if (json['prospectlostreason'] != null) {
      prospectlostreason = DBType.fromJson(json['prospectlostreason']);
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
    data['prospectexpclosedate'] = prospectexpclosedate;
    data['prospectbpid'] = prospectbpid;
    data['prospectdescription'] = prospectdescription;
    data['prospectcustid'] = prospectcustid;
    data['prospectrefid'] = prospectrefid;
    data['prospectlostreasonid'] = prospectlostreasonid;
    data['prospectlostdesc'] = prospectlostdesc;

    if (prospectowneruser != null) {
      data['prospectowneruser'] = prospectowneruser?.toJson();
    }

    if (prospectstage != null) {
      data['prospectstage'] = prospectstage?.toJson();
    }

    if (prospectstatus != null) {
      data['prospectstatus'] = prospectstatus?.toJson();
    }

    if (prospectlostreason != null) {
      data['prospectlostreason'] = prospectlostreason?.toJson();
    }

    if (prospectcust != null) {
      data['prospectcust'] = prospectcust?.toJson();
    }

    return data;
  }
}
