import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/app/api/models/customer_model.dart';
import 'package:ventes/app/api/models/files_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class BpCustomer extends Model {
  int? sbcid;
  int? sbcbpid;
  int? sbccstmid;
  String? sbccstmname;
  String? sbccstmphone;
  String? sbccstmaddress;
  int? sbccstmstatusid;
  DBType? sbccstmstatus;
  BusinessPartner? sbcbp;
  Customer? sbccstm;
  List<Files>? sbccstmpics;

  ///
  /// radus in meter
  double? radius;

  BpCustomer({
    this.sbcid,
    this.sbcbpid,
    this.sbccstmid,
    this.sbccstmname,
    this.sbccstmphone,
    this.sbccstmaddress,
    this.sbccstmpics,
    this.sbcbp,
    this.sbccstm,
    this.radius,
    this.sbccstmstatusid,
    this.sbccstmstatus,
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

  BpCustomer.fromJson(Map<String, dynamic> json) {
    sbcid = json['sbcid'];
    sbcbpid = json['sbcbpid'];
    sbccstmid = json['sbccstmid'];
    sbccstmname = json['sbccstmname'];
    sbccstmphone = json['sbccstmphone'];
    sbccstmaddress = json['sbccstmaddress'];
    sbccstmstatusid = json['sbccstmstatusid'];

    if (json['sbcbp'] != null) {
      sbcbp = BusinessPartner.fromJson(json['sbcbp']);
    }

    if (json['sbccstm'] != null) {
      sbccstm = Customer.fromJson(json['sbccstm']);
    }

    if (json['sbccstmstatus'] != null) {
      sbccstmstatus = DBType.fromJson(json['sbccstmstatus']);
    }

    if (json['sbccstmpics'] != null && json['sbccstmpics'].isNotEmpty) {
      sbccstmpics = json['sbccstmpics'].map<Files>((e) => Files.fromJson(e)).toList();
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['sbcid'] = sbcid;
    data['sbcbpid'] = sbcbpid;
    data['sbccstmid'] = sbccstmid;
    data['sbccstmname'] = sbccstmname;
    data['sbccstmphone'] = sbccstmphone;
    data['sbccstmaddress'] = sbccstmaddress;
    data['sbccstmstatusid'] = sbccstmstatusid;

    if (sbcbp != null) {
      data['sbcbp'] = sbcbp?.toJson();
    }

    if (sbccstm != null) {
      data['sbccstm'] = sbccstm?.toJson();
    }

    if (sbccstmstatus != null) {
      data['sbccstmstatus'] = sbccstmstatus?.toJson();
    }

    if (sbccstmpics != null) {
      data['sbccstmpics'] = sbccstmpics?.map((e) => e.toJson());
    }

    return data;
  }
}
