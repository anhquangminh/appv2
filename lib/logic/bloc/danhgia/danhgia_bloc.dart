import 'package:bloc/bloc.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_event.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_reponsitory.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_state.dart';

class DanhGiaBloc extends Bloc<DanhGiaEvent, DanhGiaState> {
  final DanhGiaRepository repository;

  DanhGiaBloc(this.repository) : super(DanhGiaInitial()) {
    on<LoadDanhGiaByIdEvent>(_onLoadDanhGiaById);
    on<LoadDanhGiaByIdCongViecEvent>(_onLoadDanhGiaByIdCongViec);
    on<CreateDanhGiaEvent>(_onCreateDanhGia);
    on<UpdateDanhGiaEvent>(_onUpdateDanhGia);
  }

  Future<void> _onLoadDanhGiaById(
      LoadDanhGiaByIdEvent event, Emitter<DanhGiaState> emit) async {
    emit(DanhGiaLoading());
    try {
      final danhGia = await repository.getById(event.id);
      emit(DanhGiaLoaded(danhGia: danhGia));
    } catch (e) {
      emit(DanhGiaError(e.toString()));
    }
  }

  Future<void> _onLoadDanhGiaByIdCongViec(
      LoadDanhGiaByIdCongViecEvent event, Emitter<DanhGiaState> emit) async {
    emit(DanhGiaLoading());
    try {
      // Lấy đánh giá theo idCongViec (sẽ trả về DanhGiaModel)
      final danhGia = await repository.getByIdCongViec(event.idCongViec);
      emit(DanhGiaLoadedIdCongViec(danhGia: danhGia));
    } catch (e) {
      emit(DanhGiaError(e.toString()));
    }
  }

  Future<void> _onCreateDanhGia(
      CreateDanhGiaEvent event, Emitter<DanhGiaState> emit) async {
    emit(DanhGiaLoading());
    try {
      final newDanhGia = await repository.create(event.model, event.userName);
      // ignore: avoid_print
      print(newDanhGia);
      emit(DanhGiaSuccess());
    } catch (e) {
      emit(DanhGiaError(e.toString()));
    }
  }

  Future<void> _onUpdateDanhGia(
      UpdateDanhGiaEvent event, Emitter<DanhGiaState> emit) async {
    emit(DanhGiaLoading());
    try {
      final updatedDanhGia =
          await repository.update(event.model, event.userName);
          // ignore: avoid_print
          print(updatedDanhGia);
      emit(DanhGiaSuccess());
    } catch (e) {
      emit(DanhGiaError(e.toString()));
    }
  }
}
