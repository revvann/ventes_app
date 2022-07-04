import 'package:ventes/core/api/model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';

class User extends Model {
  int? userid;
  String? username;
  String? userpassword;
  String? userfullname;
  String? useremail;
  String? userphone;
  String? userdeviceid;
  String? userfcmtoken;
  String? usersocketid;
  List<UserDetail>? userdetails;

  User({
    this.userid,
    this.username,
    this.userpassword,
    this.userfullname,
    this.useremail,
    this.userphone,
    this.userdeviceid,
    this.usersocketid,
    this.userfcmtoken,
    int? createdby,
    String? createddate,
    int? updatedby,
    String? updateddate,
    bool? isactive,
    this.userdetails,
  }) : super(
          createdby: createdby,
          updatedby: updatedby,
          createddate: createddate,
          updateddate: updateddate,
          isactive: isactive,
        );

  User.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    userpassword = json['userpassword'];
    userfullname = json['userfullname'];
    useremail = json['useremail'];
    userphone = json['userphone'];
    userdeviceid = json['userdeviceid'];
    userfcmtoken = json['userfcmtoken'];
    usersocketid = json['usersocketid'];
    if (json['userdetails'] != null) {
      userdetails = <UserDetail>[];
      json['userdetails'].forEach((v) {
        userdetails!.add(UserDetail.fromJson(v));
      });
    }
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['userid'] = userid;
    data['username'] = username;
    data['userpassword'] = userpassword;
    data['userfullname'] = userfullname;
    data['useremail'] = useremail;
    data['userphone'] = userphone;
    data['userdeviceid'] = userdeviceid;
    data['userfcmtoken'] = userfcmtoken;
    data['usersocketid'] = usersocketid;
    if (userdetails != null) {
      data['userdetails'] = userdetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
