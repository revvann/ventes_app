import 'package:ventes/models/business_partner_model.dart';
import 'package:ventes/models/regular_model.dart';
import 'package:ventes/models/type_model.dart';
import 'package:ventes/models/user_model.dart';

class UserDetail extends RegularModel {
  int? userdtid;
  int? userid;
  int? userdttypeid;
  int? userdtbpid;
  String? userdtbranchnm;
  String? userdtreferalcode;
  int? userdtrelationid;
  DBType? usertype;
  BusinessPartner? businesspartner;
  User? user;

  UserDetail({
    this.userdtid,
    this.userid,
    this.userdttypeid,
    this.userdtbpid,
    this.userdtbranchnm,
    this.userdtreferalcode,
    this.userdtrelationid,
    String? createddate,
    String? updateddate,
    int? createdby,
    int? updatedby,
    bool? isactive,
    this.usertype,
    this.businesspartner,
    this.user,
  }) : super(
          createdby: createdby,
          createddate: createddate,
          updatedby: updatedby,
          updateddate: updateddate,
          isactive: isactive,
        );

  UserDetail.fromJson(Map<String, dynamic> json) {
    userdtid = json['userdtid'];
    userid = json['userid'];
    userdttypeid = json['userdttypeid'];
    userdtbpid = json['userdtbpid'];
    userdtbranchnm = json['userdtbranchnm'];
    userdtreferalcode = json['userdtreferalcode'];
    userdtrelationid = json['userdtrelationid'];
    usertype = json['usertype'] != null ? DBType.fromJson(json['usertype']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    businesspartner = json['businesspartner'] != null ? BusinessPartner.fromJson(json['businesspartner']) : null;
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['userdtid'] = userdtid;
    data['userid'] = userid;
    data['userdttypeid'] = userdttypeid;
    data['userdtbpid'] = userdtbpid;
    data['userdtbranchnm'] = userdtbranchnm;
    data['userdtreferalcode'] = userdtreferalcode;
    data['userdtrelationid'] = userdtrelationid;
    if (usertype != null) {
      data['usertype'] = usertype!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (businesspartner != null) {
      data['businesspartner'] = businesspartner!.toJson();
    }
    return data;
  }
}
