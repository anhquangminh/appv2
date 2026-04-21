import 'package:flutter_bloc/flutter_bloc.dart';
import 'chuyenmon_event.dart';
import 'chuyenmon_state.dart';
import 'chuyenmon_repository.dart';

class ChuyenMonBloc extends Bloc<ChuyenMonEvent, ChuyenMonState> {
  final ChuyenMonRepository repository;

  ChuyenMonBloc({required this.repository}) : super(ChuyenMonInitial()) {
    on<FetchChuyenMon>((event, emit) async {
      emit(ChuyenMonLoading());
      try {
        final list = await repository.fetchChuyenMon(event.filter);
        emit(ChuyenMonLoaded(list));
      } catch (e) {
        emit(ChuyenMonError(e.toString()));
      }
    });
  }
}
