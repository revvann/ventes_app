import 'package:ventes/models/business_partner_model.dart';
import 'package:ventes/models/regular_model.dart';
import 'package:ventes/models/schedule_model.dart';
import 'package:ventes/models/type_model.dart';
import 'package:ventes/models/user_model.dart';

class ScheduleGuest extends RegularModel {
  int? scheguestid;
  int? scheid;
  int? scheuserid;
  int? schebpid;
  List<int>? schepermisid;
  Schedule? schedule;
  User? scheuser;
  BusinessPartner? schebp;
  List<DBType>? schepermis;

  ScheduleGuest(
    this.scheguestid,
    this.scheid,
    this.scheuserid,
    this.schebpid,
    this.schepermisid,
    this.schedule,
    this.scheuser,
    this.schebp,
    this.schepermis,
    String? createddate,
    String? updateddate,
    int? createdby,
    int? updatedby,
    bool? isactive,
  ) : super(
          createdby: createdby,
          updatedby: updatedby,
          createddate: createddate,
          updateddate: updateddate,
          isactive: isactive,
        );

  ScheduleGuest.fromJson(Map<String, dynamic> json) {
    scheguestid = json['scheguestid'];
    scheid = json['scheid'];
    scheuserid = json['scheuserid'];
    schebpid = json['schebpid'];
    schepermisid = json['schepermisid'];
    if (json['schedule'] != null) {
      schedule = Schedule.fromJson(json['schedule']);
    }
    if (json['scheuser'] != null) {
      scheuser = User.fromJson(json['scheuser']);
    }
    if (json['schebp'] != null) {
      schebp = BusinessPartner.fromJson(json['schebp']);
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
    data['scheuserid'] = scheuserid;
    data['schebpid'] = schebpid;
    data['schepermisid'] = schepermisid;
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    if (scheuser != null) {
      data['scheuser'] = scheuser!.toJson();
    }
    if (schebp != null) {
      data['schebp'] = schebp!.toJson();
    }
    if (schepermis != null) {
      data['schepermis'] = schepermis!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
