class NhomNhanVienModel {
  String id;
  String idQuanLy;
  String tenNhanVien;
  String taiKhoan;
  String tenNhom;
  String? iconName;
  int total;
  String groupId;
  String companyId;
  String companyName;
  DateTime createAt;
  String? createBy;
  int isActive;
  int pageNumber;
  int pageSize;

  NhomNhanVienModel({
    required this.id,
    required this.idQuanLy,
    required this.tenNhanVien,
    required this.taiKhoan,
    required this.tenNhom,
     this.iconName,
    required this.total,
    required this.groupId,
    required this.companyId,
    required this.companyName,
    required this.createAt,
    this.createBy,
    required this.isActive,
    required this.pageNumber,
    required this.pageSize,
  });

 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NhomNhanVienModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory NhomNhanVienModel.fromJson(Map<String, dynamic> json) {
    return NhomNhanVienModel(
      id: json["id"],
      idQuanLy: json["id_QuanLy"],
      tenNhanVien: json["tenNhanVien"],
      taiKhoan: json["taiKhoan"],
      tenNhom: json["tenNhom"],
      iconName: json["iconName"],
      total: json["total"],
      groupId: json["groupId"],
      companyId: json["companyId"],
      companyName: json["companyName"],
      createAt: DateTime.parse(json["createAt"]),
      createBy: json["createBy"],
      isActive: json["isActive"],
      pageNumber: json["page_number"],
      pageSize: json["pageSize"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "id_QuanLy": idQuanLy,
      "tenNhanVien": tenNhanVien,
      "taiKhoan": taiKhoan,
      "tenNhom": tenNhom,
      "iconName": iconName,
      "total": total,
      "groupId": groupId,
      "companyId":companyId,
      "companyName":companyName,
      "createAt": createAt.toIso8601String(),
      "createBy": createBy,
      "isActive": isActive,
      "page_number": pageNumber,
      "pageSize": pageSize,
    };
  }
}
