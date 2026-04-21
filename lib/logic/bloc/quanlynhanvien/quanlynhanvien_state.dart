part of 'quanlynhanvien_bloc.dart';

abstract class QuanLyNhanVienState extends Equatable {
  const QuanLyNhanVienState();

  @override
  List<Object> get props => [];
}

class QuanLyNhanVienInitial extends QuanLyNhanVienState {}

class QuanLyNhanVienLoading extends QuanLyNhanVienState {}

class QuanLyNhanVienLoaded extends QuanLyNhanVienState {
  final List<QuanLyNhanVienModel> quanLyNhanViens;
  final DateTime lastUpdated;

  QuanLyNhanVienLoaded({
    required this.quanLyNhanViens,
    DateTime? lastUpdated, 
  }) : lastUpdated = lastUpdated ?? DateTime(0);

  @override
  List<Object> get props => [quanLyNhanViens, lastUpdated];
}

class QuanLyNhanVienError extends QuanLyNhanVienState {
  final String message;
  final DateTime errorTime;

  QuanLyNhanVienError(
    this.message, {
    DateTime? errorTime, 
  }) : errorTime = errorTime ?? DateTime(0); 

  @override
  List<Object> get props => [message, errorTime];
}


class QuanLyNhanVienVMLoaded extends QuanLyNhanVienState {
  final List<QuanLyNhanVienModel> quanLyNhanViens;
  final String groupId;

  const QuanLyNhanVienVMLoaded({required this.quanLyNhanViens, required this.groupId});

  @override
  List<Object> get props => [quanLyNhanViens, groupId];
}

class QuanLyNhanVienSuccess extends QuanLyNhanVienState {
  final String message;
  const QuanLyNhanVienSuccess(this.message);
}

