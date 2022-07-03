import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/core/api/model.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_model.dart';

class ScheduleGuest extends Model {
  int? scheguestid;
  int? scheid;
  int? scheuserid;
  int? schebpid;
  List<int>? schepermisid;
  Schedule? schedule;
  User? scheuser;
  BusinessPartner? businesspartner;
  List<DBType>? schepermis;

  ScheduleGuest({
    this.scheguestid,
    this.scheid,
    this.scheuserid,
    this.schebpid,
    this.schepermisid,
    this.schedule,
    this.scheuser,
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
    scheuserid = json['scheuserid'];
    schebpid = json['schebpid'];
    schepermisid = json['schepermisid'].replaceAll(RegExp(r'[{}]'), '').split(',').map<int>((e) => int.parse(e)).toList();
    if (json['schedule'] != null) {
      schedule = Schedule.fromJson(json['schedule']);
    }
    if (json['scheuser'] != null) {
      scheuser = User.fromJson(json['scheuser']);
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
    data['scheuserid'] = scheuserid;
    data['schebpid'] = schebpid;
    data['schepermisid'] = schepermisid != null ? "{${schepermisid?.join(',')}}" : null;
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    if (scheuser != null) {
      data['scheuser'] = scheuser!.toJson();
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
