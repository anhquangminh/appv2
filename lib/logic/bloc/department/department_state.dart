import 'package:ducanherp/data/models/dapartment_model.dart';
import 'package:equatable/equatable.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();
  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<DepartmentModel> departments;
  const DepartmentLoaded(this.departments);
  @override
  List<Object?> get props => [departments];
}

class DepartmentError extends DepartmentState {
  final String message;
  const DepartmentError(this.message);
  @override
  List<Object?> get props => [message];
}
