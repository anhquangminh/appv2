class ChiNhanhModel {
  String id;
  String parentId;
  String tenChiNhanh;
  String companyType;
  String phone;
  String email;
  String address;
  String groupId;
  int ordinarily;
  DateTime createAt;
  String createBy;
  int isActive;
  String approvalUserId;
  DateTime dateApproval;
  String approvalDept;
  String departmentId;
  int departmentOrder;
  int approvalOrder;
  String approvalId;
  String lastApprovalId;
  String isStatus;

  ChiNhanhModel({
    required this.id,
    required this.parentId,
    required this.tenChiNhanh,
    required this.companyType,
    required this.phone,
    required this.email,
    required this.address,
    required this.groupId,
    required this.ordinarily,
    required this.createAt,
    required this.createBy,
    required this.isActive,
    required this.approvalUserId,
    required this.dateApproval,
    required this.approvalDept,
    required this.departmentId,
    required this.departmentOrder,
    required this.approvalOrder,
    required this.approvalId,
    required this.lastApprovalId,
    required this.isStatus,
  });

  factory ChiNhanhModel.fromJson(Map<String, dynamic> json) {
    return ChiNhanhModel(
      id: json['id'] ?? '',
      parentId: json['parentId'] ?? '',
      tenChiNhanh: json['tenChiNhanh'] ?? '',
      companyType: json['companyType'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      groupId: json['groupId'] ?? '',
      ordinarily: json['ordinarily'] ?? 0,
      createAt: DateTime.parse(json['createAt']),
      createBy: json['createBy'] ?? '',
      isActive: json['isActive'] ?? 0,
      approvalUserId: json['approvalUserId'] ?? '',
      dateApproval: DateTime.parse(json['dateApproval']),
      approvalDept: json['approvalDept'] ?? '',
      departmentId: json['departmentId'] ?? '',
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
      'parentId': parentId,
      'tenChiNhanh': tenChiNhanh,
      'companyType': companyType,
      'phone': phone,
      'email': email,
      'address': address,
      'groupId': groupId,
      'ordinarily': ordinarily,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'approvalUserId': approvalUserId,
      'dateApproval': dateApproval.toIso8601String(),
      'approvalDept': approvalDept,
      'departmentId': departmentId,
      'departmentOrder': departmentOrder,
      'approvalOrder': approvalOrder,
      'approvalId': approvalId,
      'lastApprovalId': lastApprovalId,
      'isStatus': isStatus,
    };
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChiNhanhModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}
