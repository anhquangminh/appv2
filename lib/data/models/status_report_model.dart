class StatusReportModel {
  final int tongSo;
  final int dangThucHien;
  final int hoanThanh;
  final int cho;
  final int chuaLam;
  final int quaHan;

  StatusReportModel({
    required this.tongSo,
    required this.dangThucHien,
    required this.hoanThanh,
    required this.cho,
    required this.chuaLam,
    required this.quaHan,
  });

  factory StatusReportModel.fromJson(Map<String, dynamic> json) {
    return StatusReportModel(
      tongSo: json['tongSo'] ?? 0,
      dangThucHien: json['dangThucHien'] ?? 0,
      hoanThanh: json['hoanThanh'] ?? 0,
      cho: json['cho'] ?? 0,
      chuaLam: json['chuaLam'] ?? 0,
      quaHan: json['quaHan'] ?? 0,
    );
  }
}
