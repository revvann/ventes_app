import 'package:ventes/models/business_partner_model.dart';
import 'package:ventes/models/regular_model.dart';
import 'package:ventes/models/type_model.dart';
import 'package:ventes/models/user_model.dart';

class Schedule extends RegularModel {
  int? scheid;
  String? schenm;
  String? schestartdate;
  String? scheenddate;
  String? schestarttime;
  String? scheendtime;
  int? schetypeid;
  String? scheactdate;
  int? schetowardid;
  int? schebpid;
  int? schereftypeid;
  int? scherefid;
  bool? scheallday;
  String? scheloc;
  bool? scheprivate;
  bool? scheonline;
  String? schetz;
  int? scheremind;
  String? schedesc;
  String? scheonlink;
  DBType? schetype;
  BusinessPartner? schebp;
  User? schetoward;

  Schedule({
    this.scheid,
    this.schenm,
    this.schestartdate,
    this.scheenddate,
    this.schestarttime,
    this.scheendtime,
    this.schetypeid,
    this.scheactdate,
    this.schetowardid,
    this.schebpid,
    this.schereftypeid,
    this.scherefid,
    this.scheallday,
    this.scheloc,
    this.scheprivate,
    this.scheonline,
    this.schetz,
    this.scheremind,
    this.schedesc,
    this.scheonlink,
    this.schetype,
    this.schebp,
    this.schetoward,
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

  Schedule.fromJson(Map<String, dynamic> json) {
    scheid = json['scheid'];
    schenm = json['schenm'];
    schestartdate = json['schestartdate'];
    scheenddate = json['scheenddate'];
    schestarttime = json['schestarttime'];
    scheendtime = json['scheendtime'];
    schetypeid = json['schetypeid'];
    scheactdate = json['scheactdate'];
    schetowardid = json['schetowardid'];
    schebpid = json['schebpid'];
    schereftypeid = json['schereftypeid'];
    scherefid = json['scherefid'];
    scheallday = json['scheallday'];
    scheloc = json['scheloc'];
    scheprivate = json['scheprivate'];
    scheonline = json['scheonline'];
    schetz = json['schetz'];
    scheremind = json['scheremind'];
    schedesc = json['schedesc'];
    scheonlink = json['scheonlink'];
    if (json['schetype'] != null) {
      schetype = DBType.fromJson(json['schetype']);
    }
    if (json['schebp'] != null) {
      schebp = BusinessPartner.fromJson(json['schebp']);
    }
    if (json['schetoward'] != null) {
      schetoward = User.fromJson(json['schetoward']);
    }
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['scheid'] = scheid;
    data['schenm'] = schenm;
    data['schestartdate'] = schestartdate;
    data['scheenddate'] = scheenddate;
    data['schestarttime'] = schestarttime;
    data['scheendtime'] = scheendtime;
    data['schetypeid'] = schetypeid;
    data['scheactdate'] = scheactdate;
    data['schetowardid'] = schetowardid;
    data['schebpid'] = schebpid;
    data['schereftypeid'] = schereftypeid;
    data['scherefid'] = scherefid;
    data['scheallday'] = scheallday;
    data['scheloc'] = scheloc;
    data['scheprivate'] = scheprivate;
    data['scheonline'] = scheonline;
    data['schetz'] = schetz;
    data['scheremind'] = scheremind;
    data['schedesc'] = schedesc;
    data['scheonlink'] = scheonlink;
    if (schetype != null) {
      data['schetype'] = schetype!.toJson();
    }
    if (schebp != null) {
      data['schebp'] = schebp!.toJson();
    }
    if (schetoward != null) {
      data['schetoward'] = schetoward!.toJson();
    }
    return data;
  }
}
