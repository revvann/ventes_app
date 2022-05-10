class Model {
  int? createdby;
  String? createddate;
  int? updatedby;
  String? updateddate;
  bool? isactive;

  Model({
    this.createdby,
    this.createddate,
    this.updatedby,
    this.updateddate,
    this.isactive,
  });

  void fromJson(Map<String, dynamic> json) {
    createdby = json['createdby'];
    createddate = json['createddate'];
    updatedby = json['updatedby'];
    updateddate = json['updateddate'];
    isactive = json['isactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdby'] = createdby;
    data['createddate'] = createddate;
    data['updatedby'] = updatedby;
    data['updateddate'] = updateddate;
    data['isactive'] = isactive;
    return data;
  }
}
