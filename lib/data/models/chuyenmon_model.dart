class ChuyenMonModel {
  String id;
  String chuyenMon;
  String groupId;
  int ordinarily;
  DateTime? createAt;
  String createBy;
  int isActive;
  String approvalUserId;
  DateTime? dateApproval;
  String approvalDept;
  String departmentId;
  int departmentOrder;
  int approvalOrder;
  String approvalId;
  String lastApprovalId;
  String isStatus;
  int pageNumber;
  int pageSize;

  ChuyenMonModel({
    required this.id,
    required this.chuyenMon,
    required this.groupId,
    required this.ordinarily,
    this.createAt,
    required this.createBy,
    required this.isActive,
    required this.approvalUserId,
    this.dateApproval,
    required this.approvalDept,
    required this.departmentId,
    required this.departmentOrder,
    required this.approvalOrder,
    required this.approvalId,
    required this.lastApprovalId,
    required this.isStatus,
    required this.pageNumber,
    required this.pageSize,
  });

  factory ChuyenMonModel.fromJson(Map<String, dynamic> json) {
    return ChuyenMonModel(
      id: json['id'] ?? '',
      chuyenMon: json['chuyenMon'] ?? '',
      groupId: json['groupId'] ?? '',
      ordinarily: json['ordinarily'] ?? 0,
      createAt: json['createAt'] != null ? DateTime.tryParse(json['createAt']) : null,
      createBy: json['createBy'] ?? '',
      isActive: json['isActive'] ?? 0,
      approvalUserId: json['approvalUserId'] ?? '',
      dateApproval: json['DateApproval'] != null ? DateTime.tryParse(json['dateApproval']) : null,
      approvalDept: json['approvalDept'] ?? '',
      departmentId: json['departmentId'] ?? '',
      departmentOrder: json['departmentOrder'] ?? 0,
      approvalOrder: json['approvalOrder'] ?? 0,
      approvalId: json['approvalId'] ?? '',
      lastApprovalId: json['lastApprovalId'] ?? '',
      isStatus: json['isStatus'] ?? '',
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? json['pageSize'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'ChuyenMon': chuyenMon,
      'GroupId': groupId,
      'Ordinarily': ordinarily,
      'CreateAt': createAt?.toIso8601String(),
      'CreateBy': createBy,
      'IsActive': isActive,
      'ApprovalUserId': approvalUserId,
      'DateApproval': dateApproval?.toIso8601String(),
      'ApprovalDept': approvalDept,
      'DepartmentId': departmentId,
      'DepartmentOrder': departmentOrder,
      'ApprovalOrder': approvalOrder,
      'ApprovalId': approvalId,
      'LastApprovalId': lastApprovalId,
      'IsStatus': isStatus,
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
  }
}
