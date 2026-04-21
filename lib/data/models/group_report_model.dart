class GroupReportModel {
  final String nhomCongViec;
  final String tenNhom;
  final String iconName;
  final int soLuong;

  GroupReportModel({
    required this.nhomCongViec,
    required this.tenNhom,
    required this.iconName,
    required this.soLuong,
  });

  factory GroupReportModel.fromJson(Map<String, dynamic> json) {
    return GroupReportModel(
      nhomCongViec: json['nhomCongViec'] ?? '',
      tenNhom: json['tenNhom'] ?? '',
      iconName: json['iconName'] ?? '',
      soLuong: json['soLuong'] ?? 0,
    );
  }
}
