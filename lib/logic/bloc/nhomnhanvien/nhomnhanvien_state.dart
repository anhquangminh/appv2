part of 'nhomnhanvien_bloc.dart';

abstract class NhomNhanVienState extends Equatable {
  const NhomNhanVienState();

  @override
  List<Object> get props => [];
}

class NhomNhanVienInitial extends NhomNhanVienState {}

class NhomNhanVienLoading extends NhomNhanVienState {}

class NhomNhanVienLoaded extends NhomNhanVienState {
  final List<NhomNhanVienModel> nhomNhanViens;
  final DateTime lastUpdated;

  NhomNhanVienLoaded({required this.nhomNhanViens, DateTime? lastUpdated})
    : lastUpdated = lastUpdated ?? DateTime(0);

  @override
  List<Object> get props => [nhomNhanViens, lastUpdated];
}

class NhomNhanVienError extends NhomNhanVienState {
  final String message;
  final DateTime errorTime;

  NhomNhanVienError(this.message, {DateTime? errorTime})
    : errorTime = errorTime ?? DateTime(0);

  @override
  List<Object> get props => [message, errorTime];
}

class NhomNhanVienVMLoaded extends NhomNhanVienState {
  final List<NhomNhanVienModel> nhomNhanViens;
  final String groupId;

  const NhomNhanVienVMLoaded({
    required this.nhomNhanViens,
    required this.groupId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NhomNhanVienVMLoaded &&
        other.nhomNhanViens == nhomNhanViens &&
        other.groupId == groupId;
  }

  @override
  int get hashCode => nhomNhanViens.hashCode ^ groupId.hashCode;
}

class NhomNhanVienSuccess extends NhomNhanVienState {
  final String message;
  const NhomNhanVienSuccess(this.message);
}

class NhomNhanVienByCVDGLoaded extends NhomNhanVienState {
  final String groupId;
  final String taiKhoan;

  const NhomNhanVienByCVDGLoaded({
    required this.groupId,
    required this.taiKhoan,
  });

  @override
  List<Object> get props => [groupId, taiKhoan];
}

class NhomNhanVienByCVDG extends NhomNhanVienState {
  final List<NhomNhanVienModel> nhomNhanViens;
  final DateTime lastUpdated;

  NhomNhanVienByCVDG({required this.nhomNhanViens, DateTime? lastUpdated})
    : lastUpdated = lastUpdated ?? DateTime(0);

  @override
  List<Object> get props => [nhomNhanViens, lastUpdated];
}
