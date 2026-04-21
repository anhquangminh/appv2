import 'package:flutter_bloc/flutter_bloc.dart';
import 'nhanvienthuchien_event.dart';
import 'nhanvienthuchien_state.dart';
import 'nhanvienthuchien_repository.dart';

class NhanVienThucHienBloc extends Bloc<NhanVienThucHienEvent, NhanVienThucHienState> {
  final NhanVienThucHienRepository repository;

  NhanVienThucHienBloc({required this.repository}) : super(NhanVienThucHienInitial()) {
    on<FetchNhanVienThucHien>(_onFetchNhanVienThucHien);
  }

  Future<void> _onFetchNhanVienThucHien(FetchNhanVienThucHien event, Emitter<NhanVienThucHienState> emit) async {
    emit(NhanVienThucHienLoading());
    try {
      final nhanViens = await repository.fetchNhanViensByCongViec(event.congViecId, event.groupId);
      emit(NhanVienThucHienLoaded(nhanViens));
    } catch (e) {
      emit(NhanVienThucHienError(e.toString()));
    }
  }
}