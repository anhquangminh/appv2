import 'package:ducanherp/logic/bloc/chucvu/chucvu_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chucvu_event.dart';
import 'chucvu_state.dart';

class ChucVuBloc extends Bloc<ChucVuEvent, ChucVuState> {
  final ChucVuRepository repository;

  ChucVuBloc({required this.repository}) : super(ChucVuInitial()) {
    on<FetchChucVu>(_onFetchChucVu);
  }

  Future<void> _onFetchChucVu(
      FetchChucVu event, Emitter<ChucVuState> emit) async {
    emit(ChucVuLoading());

    try {
      final data = await repository.getChucVuByVM(event.chucVuModel);
      emit(ChucVuLoaded(data));
    } catch (e) {
      emit(ChucVuError(e.toString()));
    }
  }
}
