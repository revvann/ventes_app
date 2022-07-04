const Model = require('./model.js');
class ChatModel extends Model {
   chatid;
   chatbpid;
   chatmessage;
   chatrefname;
   chatrefid;
   chatfile;
   chatreadat;
   chatreceiverid;
   chatbp;
   chatreceiver;
   createdbyuser;

   constructor(
      chatid,
      chatbpid,
      chatmessage,
      chatrefname,
      chatrefid,
      chatfile,
      chatreadat,
      chatreceiverid,
      chatbp,
      chatreceiver,
      createdbyuser,
      createddate,
      updateddate,
      createdby,
      updatedby,
      isactive,
   ) {
      super(
         createddate,
         createdby,
         updateddate,
         updatedby,
         isactive
      );
      this.chatid = chatid;
      this.chatbpid = chatbpid;
      this.chatmessage = chatmessage;
      this.chatrefname = chatrefname;
      this.chatrefid = chatrefid;
      this.chatfile = chatfile;
      this.chatreadat = chatreadat;
      this.chatreceiverid = chatreceiverid;
      this.chatbp = chatbp;
      this.chatreceiver = chatreceiver;
      this.createdbyuser = createdbyuser;
   };

   static fromJson(json) {
      super.fromJson(json);
      this.chatid = json.chatid;
      this.chatbpid = json.chatbpid;
      this.chatmessage = json.chatmessage;
      this.chatrefname = json.chatrefname;
      this.chatrefid = json.chatrefid;
      this.chatfile = json.chatfile;
      this.chatreadat = json.chatreadat;
      this.chatreceiverid = json.chatreceiverid;
      this.chatbp = json.chatbp;
      this.chatreceiver = json.chatreceiver;
      this.createdbyuser = json.createdbyuser;
      return this;
   }

   toJson() {
      let data = super.toJson();
      data.chatid = this.chatid;
      data.chatbpid = this.chatbpid;
      data.chatmessage = this.chatmessage;
      data.chatrefname = this.chatrefname;
      data.chatrefid = this.chatrefid;
      data.chatfile = this.chatfile;
      data.chatreadat = this.chatreadat;
      data.chatreceiverid = this.chatreceiverid;
      data.chatbp = this.chatbp;
      data.chatreceiver = this.chatreceiver;
      data.createdbyuser = this.createdbyuser;
      return data;
   }
}

module.exports = ChatModel;