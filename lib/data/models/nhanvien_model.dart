class NhanVienModel {
   String id;
   String tenNhanVien;
   String taiKhoan;
   String companyId;
   String companyName;
   String groupId;
   String departmentId;
   String departmentName;
   String chucVuId;
   String chucVu;
   String chuyenMonId;
   String chuyenMon;
   int ordinarily;
   DateTime createAt;
   String createBy;
   int isActive;
   String approvalUserId;
   DateTime? dateApproval;
   String approvalDept;
   int departmentOrder;
   int approvalOrder;
   String approvalId;
   String lastApprovalId;
   String isStatus;

  NhanVienModel({
    required this.id,
    required this.tenNhanVien,
    required this.taiKhoan,
    required this.companyId,
    required this.companyName,
    required this.groupId,
    required this.departmentId,
    required this.departmentName,
    required this.chucVuId,
    required this.chucVu,
    required this.chuyenMonId,
    required this.chuyenMon,
    required this.ordinarily,
    required this.createAt,
    required this.createBy,
    required this.isActive,
    required this.approvalUserId,
    required this.dateApproval,
    required this.approvalDept,
    required this.departmentOrder,
    required this.approvalOrder,
    required this.approvalId,
    required this.lastApprovalId,
    required this.isStatus,
  });

  factory NhanVienModel.fromJson(Map<String, dynamic> json) {
    return NhanVienModel(
      id: json['id'] ?? '',
      tenNhanVien: json['tenNhanVien'] ?? '',
      taiKhoan: json['taiKhoan'] ?? '',
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      groupId: json['groupId'] ?? '',
      departmentId: json['departmentId'] ?? '',
      departmentName: json['departmentName'] ?? '',
      chucVuId: json['chucVuId'] ?? '',
      chucVu: json['chucVu'] ?? '',
      chuyenMonId: json['chuyenMonId'] ?? '',
      chuyenMon: json['chuyenMon'] ?? '',
      ordinarily: json['ordinarily'] ?? 0,
      createAt: DateTime.parse(json['createAt']),
      createBy: json['createBy'] ?? '',
      isActive: json['isActive'] ?? 0,
      approvalUserId: json['approvalUserId'] ?? '',
      dateApproval: json['dateApproval'] != null
          ? DateTime.parse(json['dateApproval'])
          : null,
      approvalDept: json['approvalDept'] ?? '',
      departmentOrder: json['departmentOrder'] ?? 0,
      approvalOrder: json['approvalOrder'] ?? 0,
      approvalId: json['approvalId'] ?? '',
      lastApprovalId: json['lastApprovalId'] ?? '',
      isStatus: json['isStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhanVien': tenNhanVien,
      'taiKhoan': taiKhoan,
      'companyId': companyId,
      'companyName': companyName,
      'groupId': groupId,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'chucVuId': chucVuId,
      'chucVu': chucVu,
      'chuyenMonId': chuyenMonId,
      'chuyenMon': chuyenMon,
      'ordinarily': ordinarily,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'approvalUserId': approvalUserId,
      'dateApproval': dateApproval?.toIso8601String(),
      'approvalDept': approvalDept,
      'departmentOrder': departmentOrder,
      'approvalOrder': approvalOrder,
      'approvalId': approvalId,
      'lastApprovalId': lastApprovalId,
      'isStatus': isStatus,
    };
  }
}
