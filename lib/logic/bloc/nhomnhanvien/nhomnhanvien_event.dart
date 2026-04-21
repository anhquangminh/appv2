part of 'nhomnhanvien_bloc.dart';

abstract class NhomNhanVienEvent extends Equatable {
  const NhomNhanVienEvent();

  @override
  List<Object> get props => [];
}

class LoadNhomNhanVien extends NhomNhanVienEvent {
  final String groupId;
  final String companyId;
  final String taiKhoan;

  const LoadNhomNhanVien({
    required this.groupId,
    required this.companyId,
    required this.taiKhoan,
  });

  @override
  List<Object> get props => [groupId, taiKhoan];
}

class AddNhomNhanVien extends NhomNhanVienEvent {
  final NhomNhanVienModel nhomNhanVien;
  final String userName;

  const AddNhomNhanVien(this.nhomNhanVien, this.userName);

  @override
  List<Object> get props => [nhomNhanVien, userName];
}

class UpdateNhomNhanVien extends NhomNhanVienEvent {
  final NhomNhanVienModel nhomNhanVien;
  final String userName;

  const UpdateNhomNhanVien(this.nhomNhanVien, this.userName);

  @override
  List<Object> get props => [nhomNhanVien, userName];
}

class DeleteNhomNhanVien extends NhomNhanVienEvent {
  final String id;
  final String userName;

  const DeleteNhomNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}

class RefreshNhomNhanVien extends NhomNhanVienEvent {
  const RefreshNhomNhanVien();
}

class GetNhomNhanVienByVM extends NhomNhanVienEvent {
  final NhomNhanVienModel nhomNhanVien;

  const GetNhomNhanVienByVM(this.nhomNhanVien);

  @override
  List<Object> get props => [nhomNhanVien];
}

class GetNhomNhanVienByCVDG extends NhomNhanVienEvent {
  final String groupId;
  final String taiKhoan;

  const GetNhomNhanVienByCVDG(this.groupId, this.taiKhoan);

  @override
  List<Object> get props => [groupId, taiKhoan];
}

class DuyetNhomNhanVien extends NhomNhanVienEvent {
  final String id;
  final String userName;

  const DuyetNhomNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}

class HuyDuyetNhomNhanVien extends NhomNhanVienEvent {
  final String id;
  final String userName;

  const HuyDuyetNhomNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}
