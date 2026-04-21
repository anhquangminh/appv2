import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:equatable/equatable.dart';

abstract class NhanVienThucHienState extends Equatable {
  const NhanVienThucHienState();

  @override
  List<Object> get props => [];
}

class NhanVienThucHienInitial extends NhanVienThucHienState {}

class NhanVienThucHienLoading extends NhanVienThucHienState {}

class NhanVienThucHienLoaded extends NhanVienThucHienState {
  final List<NhanVienModel> nhanViens;

  const NhanVienThucHienLoaded(this.nhanViens);

  @override
  List<Object> get props => [nhanViens];
}

class NhanVienThucHienError extends NhanVienThucHienState {
  final String message;

  const NhanVienThucHienError(this.message);

  @override
  List<Object> get props => [message];
}