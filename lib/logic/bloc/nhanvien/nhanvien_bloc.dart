import 'dart:async';
import 'package:bloc/bloc.dart';
import 'nhanvien_repository.dart';
import 'nhanvien_event.dart';
import 'nhanvien_state.dart';

class NhanVienBloc extends Bloc<NhanVienEvent, NhanVienState> {
  final NhanVienRepository repository;

  NhanVienBloc({required this.repository}) : super(NhanVienInitial()) {
    on<LoadNhanVien>(_onLoadNhanVien);
    on<GetNhanVienByVM>(_onGetNhanVienByVM);
    on<GetNhanVienByNhom>(_onGetNhanVienByNhom);
    on<AddNhanVien>(_onAddNhanVien);
    on<UpdateNhanVien>(_onUpdateNhanVien);
    on<DeleteNhanVien>(_onDeleteNhanVien);
    on<RefreshNhanVien>(_onRefreshNhanVien);
    on<DuyetNhanVien>(_onDuyetNhanVien);
    on<HuyDuyetNhanVien>(_onHuyDuyetNhanVien);
  }

  Future<void> _onLoadNhanVien(LoadNhanVien event, Emitter<NhanVienState> emit) async {
    emit(NhanVienLoading());
    try {
      final nhanViens = await repository.fetchNhanVien(
        groupId: event.groupId,
        taiKhoan: event.taiKhoan,
      );
      emit(NhanVienLoaded(nhanViens: nhanViens, lastUpdated: DateTime.now()));
    } catch (e) {
      _emitError(emit, e);
    }
  }

  Future<void> _onAddNhanVien(AddNhanVien event, Emitter<NhanVienState> emit) async {
    if (state is NhanVienByVMLoaded) {
      final currentState = state as NhanVienByVMLoaded;
      try {
         await repository.addNhanVien(event.nhanVien, event.userName);
        // emit(NhanVienByVMLoaded(
        //   nhanViens: [...currentState.nhanViens, newNhanVien],
        //   groupId: currentState.groupId,
        // ));
        emit(NhanVienSuccess('Thêm thành công'));
      } catch (e) {
        _emitError(emit, e);
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateNhanVien( UpdateNhanVien event, Emitter<NhanVienState> emit) async {
    if (state is NhanVienByVMLoaded) {
      final currentState = state as NhanVienByVMLoaded;
      try {
         await repository.updateNhanVien(event.nhanVien, event.userName);
        // final updatedList = currentState.nhanViens.map((nv) =>
        //   nv.id == updatedNhanVien.id ? updatedNhanVien : nv).toList();
        //   emit(NhanVienByVMLoaded(
        //     nhanViens: updatedList,
        //     groupId: currentState.groupId,
        //   ));
          emit(NhanVienSuccess('Cập nhật thành công'));
      } catch (e) {
        _emitError(emit, e);
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteNhanVien(DeleteNhanVien event, Emitter<NhanVienState> emit) async {
    if (state is NhanVienByVMLoaded) {
      
      try {
        await repository.deleteNhanVien(event.id, event.userName);

        emit(NhanVienSuccess('Xóa nhật thành công'));
      } catch (e) {
        _emitError(emit, e);

      }
    }
  }

Future<void> _onDuyetNhanVien(
    DuyetNhanVien event,
    Emitter<NhanVienState> emit,
  ) async {
    if (state is NhanVienByVMLoaded) {
      final currentState = state as NhanVienByVMLoaded;
      try {
        await repository.duyetNhanVien(event.id);
        emit(NhanVienSuccess('Duyệt thành công'));
      } catch (e) {
        emit(NhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onHuyDuyetNhanVien(
    HuyDuyetNhanVien event,
    Emitter<NhanVienState> emit,
  ) async {
    if (state is NhanVienByVMLoaded) {
      final currentState = state as NhanVienByVMLoaded;
      try {
        await repository.huyDuyetNhanVien(event.id);
        emit(NhanVienSuccess('Hủy duyệt thành công'));
      } catch (e) {
        emit(NhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onRefreshNhanVien(RefreshNhanVien event, Emitter<NhanVienState> emit) async {
    if (state is NhanVienLoaded) {
      final currentState = state as NhanVienLoaded;
      try {
        emit(NhanVienLoading());
        final nhanViens = await repository.fetchNhanVien(
          groupId: currentState.nhanViens.first.groupId,
          taiKhoan: currentState.nhanViens.first.taiKhoan,
        );
        emit(NhanVienLoaded(nhanViens: nhanViens, lastUpdated: DateTime.now()));
      } catch (e) {
        _emitError(emit, e);
        emit(currentState);
      }
    }
  }

  Future<void> _onGetNhanVienByVM(GetNhanVienByVM event, Emitter<NhanVienState> emit) async {
    emit(NhanVienLoading());
    try {
      final nhanViens = await repository.getNhanVienByVM(event.nhanVien);
      emit(NhanVienByVMLoaded(nhanViens: nhanViens, groupId: event.nhanVien.groupId));
    } catch (e) {
      _emitError(emit, e);
    }
  }

  Future<void> _onGetNhanVienByNhom(GetNhanVienByNhom event, Emitter<NhanVienState> emit) async {
    emit(NhanVienLoading());
    try {
      final nhanViens = await repository.GetNhanVienByNhom(
        groupId: event.groupId,
        idNhomNhanVien: event.idNhomNhanVien,
        companyId: event.companyId,
      );
      emit(NhanVienLoaded(nhanViens: nhanViens, lastUpdated: DateTime.now()));
    } catch (e) {
      _emitError(emit, e);
    }
  }

  void _emitError(Emitter<NhanVienState> emit, dynamic e) {
    emit(NhanVienError(e.toString(), errorTime: DateTime.now()));
  }
}
