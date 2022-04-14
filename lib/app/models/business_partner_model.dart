import 'package:ventes/app/models/regular_model.dart';
import 'package:ventes/app/models/type_model.dart';

class BusinessPartner extends RegularModel {
  int? bpid;
  String? bpname;
  int? bptypeid;
  String? bppicname;
  String? bpemail;
  String? bpphone;
  DBType? bptype;

  BusinessPartner({
    this.bpid,
    this.bpname,
    this.bptypeid,
    this.bppicname,
    this.bpemail,
    this.bpphone,
    String? createddate,
    String? updateddate,
    int? createdby,
    int? updatedby,
    bool? isactive,
  }) : super(
          createdby: createdby,
          updatedby: updatedby,
          createddate: createddate,
          updateddate: updateddate,
          isactive: isactive,
        );

  BusinessPartner.fromJson(Map<String, dynamic> json) {
    bpid = json['bpid'];
    bpname = json['bpname'];
    bptypeid = json['bptypeid'];
    bppicname = json['bppicname'];
    bpemail = json['bpemail'];
    bpphone = json['bpphone'];
    if (json['bptype'] != null) {
      bptype = DBType.fromJson(json['bptype']);
    }
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bpid'] = bpid;
    data['bpname'] = bpname;
    data['bptypeid'] = bptypeid;
    data['bppicname'] = bppicname;
    data['bpemail'] = bpemail;
    data['bpphone'] = bpphone;
    if (bptype != null) {
      data['bptype'] = bptype!.toJson();
    }
    return data;
  }
}
