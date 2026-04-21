import 'package:ducanherp/data/models/dapartment_model.dart';
import 'package:equatable/equatable.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
  @override
  List<Object?> get props => [];
}

class FetchDepartments extends DepartmentEvent {
  final DepartmentModel filter;
  const FetchDepartments(this.filter);
  @override
  List<Object?> get props => [filter];
}
