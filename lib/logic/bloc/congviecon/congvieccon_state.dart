// lib/logic/bloc/congvieccon/congvieccon_state.dart
import 'package:equatable/equatable.dart';
import 'package:ducanherp/data/models/congvieccon_model.dart';

abstract class CongViecConState extends Equatable {
  const CongViecConState();

  @override
  List<Object?> get props => [];
}

class CongViecConInitial extends CongViecConState {}

class CongViecConLoading extends CongViecConState {}

class CongViecConLoaded extends CongViecConState {
  final List<CongViecConModel> items;

  const CongViecConLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class CongViecConError extends CongViecConState {
  final String message;

  const CongViecConError(this.message);

  @override
  List<Object?> get props => [message];
}
