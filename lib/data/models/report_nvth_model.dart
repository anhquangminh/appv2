class ReportNVTHModel {
  final TrangThaiModel trangThai;
  final DanhGiaModel danhGia;
  final ThoiHanModel thoiHan;
  final List<UuTienModel> uuTien;
  final double tienDoTrungBinh; // 🔥 đổi sang double

  ReportNVTHModel({
    required this.trangThai,
    required this.danhGia,
    required this.thoiHan,
    required this.uuTien,
    required this.tienDoTrungBinh,
  });

  factory ReportNVTHModel.fromJson(Map<String, dynamic> json) {
    return ReportNVTHModel(
      trangThai: TrangThaiModel.fromJson(json['trangThai'] ?? {}),
      danhGia: DanhGiaModel.fromJson(json['danhGia'] ?? {}),
      thoiHan: ThoiHanModel.fromJson(json['thoiHan'] ?? {}),
      uuTien:
          (json['uuTien'] as List<dynamic>? ?? [])
              .map((e) => UuTienModel.fromJson(e))
              .toList(),
      tienDoTrungBinh: (json['tienDoTrungBinh'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TrangThaiModel {
  final int tongSo;
  final int dangThucHien;
  final int hoanThanh;
  final int cho;
  final int chuaLam;
  final int quaHan;

  TrangThaiModel({
    required this.tongSo,
    required this.dangThucHien,
    required this.hoanThanh,
    required this.cho,
    required this.chuaLam,
    required this.quaHan,
  });

  factory TrangThaiModel.fromJson(Map<String, dynamic> json) {
    return TrangThaiModel(
      tongSo: json['tongSo'] ?? 0,
      dangThucHien: json['dangThucHien'] ?? 0,
      hoanThanh: json['hoanThanh'] ?? 0,
      cho: json['cho'] ?? 0,
      chuaLam: json['chuaLam'] ?? 0,
      quaHan: json['quaHan'] ?? 0,
    );
  }
}

class DanhGiaModel {
  final int daDanhGia;
  final int chuaDanhGia;

  DanhGiaModel({required this.daDanhGia, required this.chuaDanhGia});

  factory DanhGiaModel.fromJson(Map<String, dynamic> json) {
    return DanhGiaModel(
      daDanhGia: json['daDanhGia'] ?? 0,
      chuaDanhGia: json['chuaDanhGia'] ?? 0,
    );
  }
}

class ThoiHanModel {
  final int dungHan;
  final int quaHan;
  final int sapQuaHan;

  ThoiHanModel({
    required this.dungHan,
    required this.quaHan,
    required this.sapQuaHan,
  });

  factory ThoiHanModel.fromJson(Map<String, dynamic> json) {
    return ThoiHanModel(
      dungHan: json['dungHan'] ?? 0,
      quaHan: json['quaHan'] ?? 0,
      sapQuaHan: json['sapQuaHan'] ?? 0,
    );
  }
}

class UuTienModel {
  final String mucDoUuTien;
  final int soLuong;

  UuTienModel({required this.mucDoUuTien, required this.soLuong});

  factory UuTienModel.fromJson(Map<String, dynamic> json) {
    return UuTienModel(
      mucDoUuTien: json['mucDoUuTien'] ?? '',
      soLuong: json['soLuong'] ?? 0,
    );
  }
}
