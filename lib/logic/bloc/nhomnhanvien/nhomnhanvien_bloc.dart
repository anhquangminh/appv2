import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/nhomnhanvien_model.dart';
import 'nhomnhanvien_repository.dart';

part 'nhomnhanvien_event.dart';
part 'nhomnhanvien_state.dart';

class NhomNhanVienBloc extends Bloc<NhomNhanVienEvent, NhomNhanVienState> {
  late final NhomNhanVienRepository repository;

  NhomNhanVienBloc({required this.repository}) : super(NhomNhanVienInitial()) {
    on<LoadNhomNhanVien>(_onLoadNhomNhanVien);
    on<AddNhomNhanVien>(_onAddNhomNhanVien);
    on<UpdateNhomNhanVien>(_onUpdateNhomNhanVien);
    on<DeleteNhomNhanVien>(_onDeleteNhomNhanVien);
    on<RefreshNhomNhanVien>(_onRefreshNhomNhanVien);
    on<GetNhomNhanVienByVM>(_onGetNhomNhanVienByVM);
    on<GetNhomNhanVienByCVDG>(_onGetNhomNhanVienByCVDG);
    on<DuyetNhomNhanVien>(_onDuyetNhomNhanVien);
    on<HuyDuyetNhomNhanVien>(_onHuyDuyetNhomNhanVien);
  }

  Future<void> _onLoadNhomNhanVien(
    LoadNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    try {
      emit(NhomNhanVienLoading());
      final nhomNhanViens = await repository.fetchNhomNhanVien(
        groupId: event.groupId,
        companyId: event.companyId,
        taiKhoan: event.taiKhoan,
      );
      emit(
        NhomNhanVienLoaded(
          nhomNhanViens: nhomNhanViens,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onDuyetNhomNhanVien(
    DuyetNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    if (state is NhomNhanVienVMLoaded) {
      final currentState = state as NhomNhanVienVMLoaded;
      try {
        emit(NhomNhanVienLoading());
        await repository.duyetNhomNhanVien(event.id);
        emit(NhomNhanVienSuccess('Duyệt thành công'));
      } catch (e) {
        emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onHuyDuyetNhomNhanVien(
    HuyDuyetNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    if (state is NhomNhanVienVMLoaded) {
      final currentState = state as NhomNhanVienVMLoaded;
      try {
        emit(NhomNhanVienLoading());
        await repository.huyDuyetNhomNhanVien(event.id);
        emit(NhomNhanVienSuccess('Hủy duyệt thành công'));
      } catch (e) {
        emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onAddNhomNhanVien(
    AddNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    if (state is NhomNhanVienVMLoaded) {
      final currentState = state as NhomNhanVienVMLoaded;
      try {
        await repository.addNhomNhanVien(event.nhomNhanVien, event.userName);
        emit(NhomNhanVienSuccess('Thêm thành công'));
      } catch (e) {
        emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateNhomNhanVien(
    UpdateNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    if (state is NhomNhanVienVMLoaded) {
      final currentState = state as NhomNhanVienVMLoaded;
      try {
        await repository.updateNhomNhanVien(event.nhomNhanVien, event.userName);
        emit(NhomNhanVienSuccess('Cập nhật thành công'));
      } catch (e) {
        emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteNhomNhanVien(
    DeleteNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
      try {
        await repository.deleteNhomNhanVien(event.id, event.userName);
        emit(NhomNhanVienSuccess('Xóa thành công'));
      } catch (e) {
        emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
      }
  }

  Future<void> _onRefreshNhomNhanVien(
    RefreshNhomNhanVien event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    if (state is NhomNhanVienLoaded) {
      final currentState = state as NhomNhanVienLoaded;
      try {
        emit(NhomNhanVienLoading());
        final nhomNhanViens = await repository.fetchNhomNhanVien(
          groupId: currentState.nhomNhanViens.first.groupId,
          companyId: "",
          taiKhoan: currentState.nhomNhanViens.first.taiKhoan,
        );
        emit(
          NhomNhanVienLoaded(
            nhomNhanViens: nhomNhanViens,
            lastUpdated: DateTime.now(),
          ),
        );
      } catch (e) {
        emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetNhomNhanVienByVM(
    GetNhomNhanVienByVM event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    try {
      final nhomnhanviens = await repository.getNhomNhanVienByVM(
        event.nhomNhanVien,
      );
      emit(
        NhomNhanVienVMLoaded(
          nhomNhanViens: nhomnhanviens,
          groupId: event.nhomNhanVien.groupId,
        ),
      );
    } catch (e) {
      emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetNhomNhanVienByCVDG(
    GetNhomNhanVienByCVDG event,
    Emitter<NhomNhanVienState> emit,
  ) async {
    try {
      final nhomnhanviens = await repository.GetNhomNhanVienByCVDG(
        event.groupId,
        event.taiKhoan,
      );
      emit(
        NhomNhanVienByCVDG(
          nhomNhanViens: nhomnhanviens,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(NhomNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }
}
