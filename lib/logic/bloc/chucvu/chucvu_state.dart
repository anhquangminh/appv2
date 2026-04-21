import 'package:ducanherp/data/models/chucvu_model.dart';

abstract class ChucVuState {}

class ChucVuInitial extends ChucVuState {}

class ChucVuLoading extends ChucVuState {}

class ChucVuLoaded extends ChucVuState {
  final List<ChucVuModel> chucVus;

  ChucVuLoaded(this.chucVus);
}

class ChucVuError extends ChucVuState {
  final String message;

  ChucVuError(this.message);
}
