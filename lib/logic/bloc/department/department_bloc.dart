import 'package:flutter_bloc/flutter_bloc.dart';
import 'department_event.dart';
import 'department_state.dart';
import 'department_repository.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository repository;

  DepartmentBloc({required this.repository}) : super(DepartmentInitial()) {
    on<FetchDepartments>((event, emit) async {
      emit(DepartmentLoading());
      try {
        final departments = await repository.fetchDepartments(event.filter);
        emit(DepartmentLoaded(departments));
      } catch (e) {
        emit(DepartmentError(e.toString()));
      }
    });
  }
}
