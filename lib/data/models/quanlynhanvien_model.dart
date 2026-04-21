class QuanLyNhanVienModel {
  String id;
  String idNhomNhanVien;
  String tenNhom;
  String iconName;
  String idNhanVien;
  String tenNhanVien;
  String taiKhoan;
  String groupId;
  String companyId;
  String companyName;
  DateTime createAt;
  String createBy;
  int isActive;
  int pageNumber;
  int pageSize;

  QuanLyNhanVienModel({
    this.id = '',
    this.idNhomNhanVien = '',
    this.tenNhom = '',
    this.iconName = '',
    this.idNhanVien = '',
    this.tenNhanVien = '',
    this.taiKhoan = '',
    this.groupId = '',
        required this.companyId,
    required this.companyName,
    DateTime? createAt,
    this.createBy = '',
    this.isActive = 1,
    this.pageNumber = 1,
    this.pageSize = 10,
  }) : createAt = createAt ?? DateTime.now().toUtc();

  factory QuanLyNhanVienModel.fromJson(Map<String, dynamic> json) {
    return QuanLyNhanVienModel(
      id: json['id'] ?? '',
      idNhomNhanVien: json['id_NhomNhanVien'] ?? '',
      tenNhom: json['tenNhom'] ?? '',
      iconName: json['iconName'] ?? '',
      idNhanVien: json['id_NhanVien'] ?? '',
      tenNhanVien: json['tenNhanVien'] ?? '',
      taiKhoan: json['taiKhoan'] ?? '',
      groupId: json['groupId'] ?? '',
      companyId: json["companyId"],
      companyName: json["companyName"],
      createAt: DateTime.tryParse(json['createAt'] ?? '') ?? DateTime.now().toUtc(),
      createBy: json['createBy'] ?? '',
      isActive: json['isActive'] ?? 1,
      pageNumber: json['page_number'] ?? 1,
      pageSize: json['pageSize'] ?? json['page_size'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_NhomNhanVien': idNhomNhanVien,
      'tenNhom': tenNhom,
      'iconName': iconName,
      'id_NhanVien': idNhanVien,
      'tenNhanVien': tenNhanVien,
      'taiKhoan': taiKhoan,
      'groupId': groupId,
      'companyId':companyId,
      'companyName':companyName,
      'createAt': createAt.toUtc().toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'page_number': pageNumber,
      'pageSize': pageSize,
    };
  }
}
