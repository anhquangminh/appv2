import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:equatable/equatable.dart';
import 'quanlynhanvien_repository.dart';

part 'quanlynhanvien_event.dart';
part 'quanlynhanvien_state.dart';

class QuanLyNhanVienBloc
    extends Bloc<QuanLyNhanVienEvent, QuanLyNhanVienState> {
  late final QuanLyNhanVienRepository repository;

  QuanLyNhanVienBloc({required this.repository})
    : super(QuanLyNhanVienInitial()) {
    on<LoadQuanLyNhanVien>(_onLoadQuanLyNhanVien);
    on<AddQuanLyNhanVien>(_onAddQuanLyNhanVien);
    on<UpdateQuanLyNhanVien>(_onUpdateQuanLyNhanVien);
    on<DeleteQuanLyNhanVien>(_onDeleteQuanLyNhanVien);
    on<RefreshQuanLyNhanVien>(_onRefreshQuanLyNhanVien);
    on<GetQuanLyNhanVienByVM>(_onGetQuanLyNhanVienByVM);
    on<DuyetQuanLyNhanVien>(_onDuyetQuanLyNhanVien);
    on<HuyDuyetQuanLyNhanVien>(_onHuyDuyetQuanLyNhanVien);
  }

  Future<void> _onLoadQuanLyNhanVien(
    LoadQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    try {
      emit(QuanLyNhanVienLoading());
      await repository.fetchQuanLyNhanVien(
        groupId: event.groupId,
        taiKhoan: event.taiKhoan,
      );
      emit(QuanLyNhanVienSuccess('Thêm thành công'));
    } catch (e) {
      emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onAddQuanLyNhanVien(
    AddQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    if (state is QuanLyNhanVienVMLoaded) {
      final currentState = state as QuanLyNhanVienVMLoaded;
      try {
        await repository.addQuanLyNhanVien(
          event.quanLyNhanVien,
          event.userName,
        );
        emit(QuanLyNhanVienSuccess('Thêm thành công'));
      } catch (e) {
        emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateQuanLyNhanVien(
    UpdateQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    if (state is QuanLyNhanVienVMLoaded) {
      final currentState = state as QuanLyNhanVienVMLoaded;
      try {
        await repository.updateQuanLyNhanVien(
          event.quanLyNhanVien,
          event.userName,
        );
        emit(QuanLyNhanVienSuccess('Cập nhật thành công'));
      } catch (e) {
        emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteQuanLyNhanVien(
    DeleteQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    try {
      await repository.deleteQuanLyNhanVien(event.id, event.userName);
      emit(QuanLyNhanVienSuccess('Xóa thành công'));
    } catch (e) {
      emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onRefreshQuanLyNhanVien(
    RefreshQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    if (state is QuanLyNhanVienLoaded) {
      final currentState = state as QuanLyNhanVienLoaded;
      try {
        emit(QuanLyNhanVienLoading());
        final quanLyNhanViens = await repository.fetchQuanLyNhanVien(
          groupId: currentState.quanLyNhanViens.first.groupId,
          taiKhoan: currentState.quanLyNhanViens.first.taiKhoan,
        );
        emit(
          QuanLyNhanVienLoaded(
            quanLyNhanViens: quanLyNhanViens,
            lastUpdated: DateTime.now(),
          ),
        );
      } catch (e) {
        emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetQuanLyNhanVienByVM(
    GetQuanLyNhanVienByVM event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    try {
      final quanLyNhanViens = await repository.getQuanLyNhanVienByVM(
        event.quanLyNhanVien,
      );
      emit(
        QuanLyNhanVienVMLoaded(
          quanLyNhanViens: quanLyNhanViens,
          groupId: event.quanLyNhanVien.groupId,
        ),
      );
    } catch (e) {
      emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onDuyetQuanLyNhanVien(
    DuyetQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    try {
      await repository.duyetQuanLyNhanVien(event.id);
      emit(QuanLyNhanVienSuccess('Duyệt thành công'));
    } catch (e) {
      emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onHuyDuyetQuanLyNhanVien(
    HuyDuyetQuanLyNhanVien event,
    Emitter<QuanLyNhanVienState> emit,
  ) async {
    try {
      await repository.huyDuyetQuanLyNhanVien(event.id);
      emit(QuanLyNhanVienSuccess('Hủy duyệt thành công'));
    } catch (e) {
      emit(QuanLyNhanVienError(e.toString(), errorTime: DateTime.now()));
    }
  }
}
