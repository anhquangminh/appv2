import 'package:equatable/equatable.dart';

abstract class NhanVienThucHienEvent extends Equatable {
  const NhanVienThucHienEvent();

  @override
  List<Object> get props => [];
}

class FetchNhanVienThucHien extends NhanVienThucHienEvent {
  final String congViecId;
  final String groupId;

  const FetchNhanVienThucHien({required this.congViecId, required this.groupId});

  @override
  List<Object> get props => [congViecId, groupId];
}