import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chinhanh_event.dart';
import 'chinhanh_state.dart';


class ChiNhanhBloc extends Bloc<ChiNhanhEvent, ChiNhanhState> {
  final ChiNhanhRepository repository;

  ChiNhanhBloc(this.repository) : super(ChiNhanhInitial()) {
    on<FetchChiNhanh>(_onFetchChiNhanh);
  }

  Future<void> _onFetchChiNhanh(
    FetchChiNhanh event,
    Emitter<ChiNhanhState> emit,
  ) async {
    emit(ChiNhanhLoading());
    try {
      final list = await repository.fetchChiNhanh(groupId:event.groupId);
      emit(ChiNhanhLoaded(list));
    } catch (e) {
      emit(ChiNhanhError(e.toString()));
    }
  }
}
