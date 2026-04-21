import 'dart:convert';

class DuyetModel {
  final String id;
  final String title;
  final String content;
  final int isActive;
  final String originalId;
  final String relatedTable;
  final String parentMajorId;
  final String parentName;
  final String majorId;
  final String majorName;
  final String companyId;
  final String groupId;
  final int ordinarily;
  final String? approvalUserId;
  final DateTime? dateApproval;
  final String? approvalDept;
  final String? departmentId;
  final int? departmentOrder;
  final int? approvalOrder;
  final String? approvalId;
  final String? lastApprovalId;
  final String isStatus;
  final DateTime? createAt;
  final String createBy;

  const DuyetModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isActive,
    required this.originalId,
    required this.relatedTable,
    required this.parentMajorId,
    required this.parentName,
    required this.majorId,
    required this.majorName,
    required this.companyId,
    required this.groupId,
    required this.ordinarily,
    this.approvalUserId,
    this.dateApproval,
    this.approvalDept,
    this.departmentId,
    this.departmentOrder,
    this.approvalOrder,
    this.approvalId,
    this.lastApprovalId,
    required this.isStatus,
    this.createAt,
    required this.createBy,
  });

  factory DuyetModel.fromJson(Map<String, dynamic> json) {
    return DuyetModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isActive: json['isActive'] ?? 0,
      originalId: json['originalId'] ?? '',
      relatedTable: json['relatedTable'] ?? '',
      parentMajorId: json['parentMajorId'] ?? '',
      parentName: json['parentName'] ?? '',
      majorId: json['majorId'] ?? '',
      majorName: json['majorName'] ?? '',
      companyId: json['companyId'] ?? '',
      groupId: json['groupId'] ?? '',
      ordinarily: json['ordinarily'] ?? 0,
      approvalUserId: json['approvalUserId'],
      dateApproval: json['dateApproval'] != null 
          ? DateTime.parse(json['dateApproval'])
          : null,
      approvalDept: json['approvalDept'],
      departmentId: json['departmentId'],
      departmentOrder: json['departmentOrder'],
      approvalOrder: json['approvalOrder'],
      approvalId: json['approvalId'],
      lastApprovalId: json['lastApprovalId'],
      isStatus: json['isStatus'] ?? '',
      createAt: json['createAt'] != null 
          ? DateTime.parse(json['createAt'])
          : null,
      createBy: json['createBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isActive': isActive,
      'originalId': originalId,
      'relatedTable': relatedTable,
      'parentMajorId': parentMajorId,
      'parentName': parentName,
      'majorId': majorId,
      'majorName': majorName,
      'companyId': companyId,
      'groupId': groupId,
      'ordinarily': ordinarily,
      'approvalUserId': approvalUserId,
      'dateApproval': dateApproval?.toIso8601String(),
      'approvalDept': approvalDept,
      'departmentId': departmentId,
      'departmentOrder': departmentOrder,
      'approvalOrder': approvalOrder,
      'approvalId': approvalId,
      'lastApprovalId': lastApprovalId,
      'isStatus': isStatus,
      'createAt': createAt?.toIso8601String(),
      'createBy': createBy,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  DuyetModel copyWith({
    String? id,
    String? title,
    String? content,
    int? isActive,
    String? originalId,
    String? relatedTable,
    String? parentMajorId,
    String? parentName,
    String? majorId,
    String? majorName,
    String? companyId,
    String? groupId,
    int? ordinarily,
    String? approvalUserId,
    DateTime? dateApproval,
    String? approvalDept,
    String? departmentId,
    int? departmentOrder,
    int? approvalOrder,
    String? approvalId,
    String? lastApprovalId,
    String? isStatus,
    DateTime? createAt,
    String? createBy,
  }) {
    return DuyetModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isActive: isActive ?? this.isActive,
      originalId: originalId ?? this.originalId,
      relatedTable: relatedTable ?? this.relatedTable,
      parentMajorId: parentMajorId ?? this.parentMajorId,
      parentName: parentName ?? this.parentName,
      majorId: majorId ?? this.majorId,
      majorName: majorName ?? this.majorName,
      companyId: companyId ?? this.companyId,
      groupId: groupId ?? this.groupId,
      ordinarily: ordinarily ?? this.ordinarily,
      approvalUserId: approvalUserId ?? this.approvalUserId,
      dateApproval: dateApproval ?? this.dateApproval,
      approvalDept: approvalDept ?? this.approvalDept,
      departmentId: departmentId ?? this.departmentId,
      departmentOrder: departmentOrder ?? this.departmentOrder,
      approvalOrder: approvalOrder ?? this.approvalOrder,
      approvalId: approvalId ?? this.approvalId,
      lastApprovalId: lastApprovalId ?? this.lastApprovalId,
      isStatus: isStatus ?? this.isStatus,
      createAt: createAt ?? this.createAt,
      createBy: createBy ?? this.createBy,
    );
  }
}