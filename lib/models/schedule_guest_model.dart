import 'package:ventes/models/business_partner_model.dart';
import 'package:ventes/models/regular_model.dart';
import 'package:ventes/models/schedule_model.dart';
import 'package:ventes/models/type_model.dart';
import 'package:ventes/models/user_model.dart';

class ScheduleGuest extends RegularModel {
  int? scheguestid;
  int? scheid;
  int? userid;
  int? schebpid;
  List<int>? schepermisid;
  Schedule? schedule;
  User? user;
  BusinessPartner? businesspartner;
  List<DBType>? schepermis;

  ScheduleGuest({
    this.scheguestid,
    this.scheid,
    this.userid,
    this.schebpid,
    this.schepermisid,
    this.schedule,
    this.user,
    this.businesspartner,
    this.schepermis,
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

  ScheduleGuest.fromJson(Map<String, dynamic> json) {
    scheguestid = json['scheguestid'];
    scheid = json['scheid'];
    userid = json['userid'];
    schebpid = json['schebpid'];
    schepermisid = json['schepermisid'];
    if (json['schedule'] != null) {
      schedule = Schedule.fromJson(json['schedule']);
    }
    if (json['scheuser'] != null) {
      user = User.fromJson(json['scheuser']);
    }
    if (json['schebp'] != null) {
      businesspartner = BusinessPartner.fromJson(json['schebp']);
    }
    if (json['schepermis'] != null && json['schepermis'].isNotEmpty) {
      schepermis = List<DBType>.from(json['schepermis'].map((e) => DBType.fromJson(e)).toList());
    }
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['scheguestid'] = scheguestid;
    data['scheid'] = scheid;
    data['userid'] = userid;
    data['schebpid'] = schebpid;
    data['schepermisid'] = schepermisid;
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    if (user != null) {
      data['scheuser'] = user!.toJson();
    }
    if (businesspartner != null) {
      data['schebp'] = businesspartner!.toJson();
    }
    if (schepermis != null) {
      data['schepermis'] = schepermis!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
