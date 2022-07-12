import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/app/api/models/files_model.dart';
import 'package:ventes/app/api/models/user_model.dart';
import 'package:ventes/core/api/model.dart';

class Chat extends Model {
  int? chatid;
  int? chatbpid;
  String? chatmessage;
  String? chatrefname;
  int? chatrefid;
  String? chatreadat;
  int? chatreceiverid;
  BusinessPartner? chatbp;
  User? chatreceiver;
  User? createdbyuser;
  Files? chatfile;

  Chat({
    this.chatid,
    this.chatbpid,
    this.chatmessage,
    this.chatrefname,
    this.chatrefid,
    this.chatfile,
    this.chatreadat,
    this.chatreceiverid,
    this.chatbp,
    this.chatreceiver,
    this.createdbyuser,
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

  Chat.fromJson(Map<String, dynamic> json) {
    chatid = json['chatid'];
    chatbpid = json['chatbpid'];
    chatmessage = json['chatmessage'];
    chatrefname = json['chatrefname'];
    chatrefid = json['chatrefid'];
    chatreadat = json['chatreadat'];
    chatreceiverid = json['chatreceiverid'];

    if (json['chatbp'] != null) chatbp = BusinessPartner.fromJson(json['chatbp']);
    if (json['chatreceiver'] != null) chatreceiver = User.fromJson(json['chatreceiver']);
    if (json['createdbyuser'] != null) createdbyuser = User.fromJson(json['createdbyuser']);
    if (json['chatfile'] != null) chatfile = Files.fromJson(json['chatfile']);
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['chatid'] = chatid;
    data['chatbpid'] = chatbpid;
    data['chatmessage'] = chatmessage;
    data['chatrefname'] = chatrefname;
    data['chatrefid'] = chatrefid;
    data['chatfile'] = chatfile;
    data['chatreadat'] = chatreadat;
    data['chatreceiverid'] = chatreceiverid;
    data['chatbp'] = chatbp;
    data['chatreceiver'] = chatreceiver;

    if (chatbp != null) {
      data['chatbp'] = chatbp?.toJson();
    }

    if (chatreceiver != null) {
      data['chatreceiver'] = chatreceiver?.toJson();
    }

    if (createdbyuser != null) {
      data['createdbyuser'] = createdbyuser?.toJson();
    }

    if (chatfile != null) {
      data['chatfile'] = chatfile?.toJson();
    }
    return data;
  }
}
