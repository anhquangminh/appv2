import 'package:equatable/equatable.dart';
import '../../../data/models/nhanvien_model.dart';


abstract class NhanVienEvent extends Equatable {
  const NhanVienEvent();

  @override
  List<Object> get props => [];
}

class GetNhanVienByVM extends NhanVienEvent {
  final NhanVienModel nhanVien;

  const GetNhanVienByVM(this.nhanVien);

  @override
  List<Object> get props => [nhanVien];
}

class LoadNhanVien extends NhanVienEvent {
  final String groupId;
  final String taiKhoan;

  const LoadNhanVien({required this.groupId, required this.taiKhoan});
  @override
  List<Object> get props => [groupId, taiKhoan];
}

class GetNhanVienByNhom extends NhanVienEvent {
  final String groupId;
  final String idNhomNhanVien;
  final String companyId;

  const GetNhanVienByNhom({required this.groupId, required this.idNhomNhanVien, required this.companyId});
  @override
  List<Object> get props => [groupId, idNhomNhanVien,companyId];
}

class AddNhanVien extends NhanVienEvent {
  final NhanVienModel nhanVien;
  final String userName;
  const AddNhanVien(this.nhanVien, this.userName);
  @override
  List<Object> get props => [nhanVien,userName];
}

class UpdateNhanVien extends NhanVienEvent {
  final NhanVienModel nhanVien;
  final String userName;
  const UpdateNhanVien(this.nhanVien, this.userName);
  @override
  List<Object> get props => [nhanVien,userName];
}

class DeleteNhanVien extends NhanVienEvent {
  final String id;
  final String userName;
  const DeleteNhanVien(this.id,this.userName);
  @override
  List<Object> get props => [id,userName];
}

class RefreshNhanVien extends NhanVienEvent {
  const RefreshNhanVien();
  @override
  List<Object> get props => [];
}

class DuyetNhanVien extends NhanVienEvent {
  final String id;
  final String userName;

  const DuyetNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}

class HuyDuyetNhanVien extends NhanVienEvent {
  final String id;
  final String userName;

  const HuyDuyetNhanVien(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}