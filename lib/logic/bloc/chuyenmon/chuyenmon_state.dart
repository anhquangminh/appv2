import 'package:ducanherp/data/models/chuyenmon_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChuyenMonState extends Equatable {
  const ChuyenMonState();
  @override
  List<Object?> get props => [];
}

class ChuyenMonInitial extends ChuyenMonState {}

class ChuyenMonLoading extends ChuyenMonState {}

class ChuyenMonLoaded extends ChuyenMonState {
  final List<ChuyenMonModel> chuyenMons;
  const ChuyenMonLoaded(this.chuyenMons);
  @override
  List<Object?> get props => [chuyenMons];
}

class ChuyenMonError extends ChuyenMonState {
  final String message;
  const ChuyenMonError(this.message);
  @override
  List<Object?> get props => [message];
}
