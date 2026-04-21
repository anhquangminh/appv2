import 'package:ducanherp/data/models/chinhanh_model.dart';

abstract class ChiNhanhState {}

class ChiNhanhInitial extends ChiNhanhState {}

class ChiNhanhLoading extends ChiNhanhState {}

class ChiNhanhLoaded extends ChiNhanhState {
  final List<ChiNhanhModel> list;

  ChiNhanhLoaded(this.list);
}

class ChiNhanhError extends ChiNhanhState {
  final String message;

  ChiNhanhError(this.message);
}
