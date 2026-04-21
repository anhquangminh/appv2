part of 'quanlynhanvien_bloc.dart';

abstract class QuanLyNhanVienEvent extends Equatable {
  const QuanLyNhanVienEvent();

  @override
  List<Object> get props => [];
}

class LoadQuanLyNhanVien extends QuanLyNhanVienEvent {
  final String groupId;
  final String taiKhoan;

  const LoadQuanLyNhanVien({
    required this.groupId,
    required this.taiKhoan,
  });

  @override
  List<Object> get props => [groupId, taiKhoan];
}

class AddQuanLyNhanVien extends QuanLyNhanVienEvent {
  final QuanLyNhanVienModel quanLyNhanVien;
  final String userName;

  const AddQuanLyNhanVien(this.quanLyNhanVien,this.userName);

  @override
  List<Object> get props => [quanLyNhanVien,userName];
}

class UpdateQuanLyNhanVien extends QuanLyNhanVienEvent {
  final QuanLyNhanVienModel quanLyNhanVien;
  final String userName;

  const UpdateQuanLyNhanVien(this.quanLyNhanVien,this.userName);

  @override
  List<Object> get props => [quanLyNhanVien,userName];
}

class DeleteQuanLyNhanVien extends QuanLyNhanVienEvent {
  final String id;
  final String userName;

  const DeleteQuanLyNhanVien(this.id,this.userName);

  @override
  List<Object> get props => [id,userName];
}

class RefreshQuanLyNhanVien extends QuanLyNhanVienEvent {
  const RefreshQuanLyNhanVien();
}

class GetQuanLyNhanVienByVM extends QuanLyNhanVienEvent {
  final QuanLyNhanVienModel quanLyNhanVien;
  
  const GetQuanLyNhanVienByVM(this.quanLyNhanVien);

  @override
  List<Object> get props => [quanLyNhanVien];
}

class GetQuanLyNhanVienByCVDG extends QuanLyNhanVienEvent {
  final String groupId;
  final String taiKhoan;
  
  const GetQuanLyNhanVienByCVDG(this.groupId, this.taiKhoan);

  @override
  List<Object> get props => [groupId, taiKhoan];
}


class DuyetQuanLyNhanVien extends QuanLyNhanVienEvent {
  final String id;
  final String userName;

  const DuyetQuanLyNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}

class HuyDuyetQuanLyNhanVien extends QuanLyNhanVienEvent {
  final String id;
  final String userName;

  const HuyDuyetQuanLyNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}
