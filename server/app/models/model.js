module.exports = class Model {
   createdby;
   createddate;
   updatedby;
   updateddate;
   isactive;

   constructor(
      createdby,
      createddate,
      updatedby,
      updateddate,
      isactive,
   ) {
      this.createdby = createdby;
      this.createddate = createddate;
      this.updatedby = updatedby;
      this.updateddate = updateddate;
      this.isactive = isactive;
   }

   static fromJson(json) {
      this.createdby = json.createdby;
      this.createddate = json.createddate;
      this.updatedby = json.updatedby;
      this.updateddate = json.updateddate;
      this.isactive = json.isactive;
      return this;
   }

   toJson() {
      let data = {};
      data.createdby = this.createdby;
      data.createddate = this.createddate;
      data.updatedby = this.updatedby;
      data.updateddate = this.updateddate;
      data.isactive = this.isactive;
      return data;
   }
}
