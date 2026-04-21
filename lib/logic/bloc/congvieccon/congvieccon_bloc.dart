// lib/logic/bloc/congvieccon/congvieccon_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'congvieccon_event.dart';
import 'congvieccon_state.dart';
import 'congvieccon_repository.dart';

class CongViecConBloc extends Bloc<CongViecConEvent, CongViecConState> {
  final CongViecConRepository repository;

  CongViecConBloc(this.repository) : super(CongViecConInitial()) {
    on<GetCongViecConByCongViecId>(_onGetByCongViecId);
  }

  Future<void> _onGetByCongViecId(
    GetCongViecConByCongViecId event,
    Emitter<CongViecConState> emit,
  ) async {
    emit(CongViecConLoading());
    try {
      final items = await repository.getByCongViecId(event.congViecId);
      emit(CongViecConLoaded(items));
    } catch (e) {
      emit(CongViecConError(e.toString()));
    }
  }
}
