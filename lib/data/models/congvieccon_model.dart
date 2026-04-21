class CongViecConModel {
  String id;
  String idCongViec;
  String noiDungCongViec;
  String? fileDinhKem;
  int? hoanThanh;
  String groupId;
  DateTime createAt;
  String createBy;
  int isActive;

  CongViecConModel({
    required this.id,
    required this.idCongViec,
    required this.noiDungCongViec,
    required this.fileDinhKem ,
    required this.hoanThanh,
    required this.groupId,
    required this.createAt,
    required this.createBy,
    this.isActive = 1,
  });
        
  factory CongViecConModel.fromJson(Map<String, dynamic> json) {
    return CongViecConModel(
      id: json['id']?.toString() ?? '',
      idCongViec: json['id_CongViec']?.toString() ?? '',
      noiDungCongViec: json['noiDungCongViec']?.toString() ?? '',
      fileDinhKem: json['fileDinhKem']?.toString(),
      hoanThanh: (json['hoanThanh'] as num?)?.toInt() ?? 0,
      groupId: json['groupId']?.toString() ?? '',
      createAt: json['createAt'] != null 
          ? DateTime.parse(json['createAt'].toString())
          : DateTime.now(),
      createBy: json['createBy']?.toString() ?? '',
      isActive: (json['isActive'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_CongViec': idCongViec,
      'noiDungCongViec': noiDungCongViec,
      'fileDinhKem': fileDinhKem,
      'hoanThanh': hoanThanh,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
    };
  }

  CongViecConModel copyWith({
    String? id,
    String? idCongViec,
    String? noiDungCongViec,
    String? fileDinhKem,
    int? hoanThanh,
    String? groupId,
    DateTime? createAt,
    String? createBy,
    int? isActive,
  }) {
    return CongViecConModel(
      id: id ?? this.id,
      idCongViec: idCongViec ?? this.idCongViec,
      noiDungCongViec: noiDungCongViec ?? this.noiDungCongViec,
      fileDinhKem: fileDinhKem ?? this.fileDinhKem,
      hoanThanh: hoanThanh ?? this.hoanThanh,
      groupId: groupId ?? this.groupId,
      createAt: createAt ?? this.createAt,
      createBy: createBy ?? this.createBy,
      isActive: isActive ?? this.isActive,
    );
  }
}

