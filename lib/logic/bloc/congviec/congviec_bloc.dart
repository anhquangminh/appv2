import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_repository.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';

class CongViecBloc extends Bloc<CongViecEvent, CongViecState> {
  final http.Client client;
  final SharedPreferences prefs;
  late final CongViecRepository repository;
  StreamSubscription? _congViecSubscription;

  CongViecBloc({required this.client, required this.prefs})
    : repository = CongViecRepository(client: client, prefs: prefs),
      super(StateCongViecInitial()) {
    on<EventLoadCongViec>(_onLoadCongViec);
    on<EventAddCongViec>(_onAddCongViec);
    on<EventUpdateCongViec>(_onUpdateCongViec);
    on<EventDeleteCongViec>(_onDeleteCongViec);
    on<EventRefreshCongViec>(_onRefreshCongViec);
    on<EventGetCongViecByVM>(_onGetCongViecByVM);
    on<EventGetCongViecById>(_onGetCongViecById);
    on<EventGetAllNVTH>(_onGetAllNVTH);
    on<EventUploadFile>(_onUploadFile);
    on<EventLoadCVCByIdCV>(_onLoadCVCByIdCV);
    on<EventUpdateCVC>(_onUpdateCVC);
    on<EventInsertCVC>(_onInsertCVC);
    on<EventLoadAllCVC>(_onLoadAllCVC);
    on<EventDeleteCVC>(_onDeleteCVC);
  }

  Future<void> _onLoadCongViec(
    EventLoadCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    emit(StateCongViecLoading());
    try {
      final congViecs = await repository.fetchCongViec(
        groupId: event.groupId,
        nguoiThucHien: event.nguoiThucHien,
      );
      emit(
        StateCongViecLoaded(congViecs: congViecs, lastUpdated: DateTime.now()),
      );
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onAddCongViec(
    EventAddCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    final currentState = state;

    emit(StateCongViecLoading());

    try {
      final newCongViec = await repository.addCongViec(
        event.congViec,
        event.themNgay,
        event.nhanViens,
      );
      emit(StateCongViecInsertSuccess());
      // Nếu trước đó là CongViecLoaded thì thêm vào danh sách cũ
      if (currentState is StateCongViecLoaded) {
        emit(
          StateCongViecLoaded(
            congViecs: [...currentState.congViecs, newCongViec],
            lastUpdated: DateTime.now(),
          ),
        );
      } else {
        // Nếu chưa có data thì tạo mới danh sách
        emit(
          StateCongViecLoaded(
            congViecs: [newCongViec],
            lastUpdated: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));

      // Optional: giữ lại state cũ nếu có
      if (currentState is StateCongViecLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateCongViec(
    EventUpdateCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    emit(StateCongViecLoading());

    try {
      final updated = await repository.updateCongViec(
        event.congViec,
        event.themNgay,
        event.nhanViens,
      );
      emit(StateCongViecUpdated(updated));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onDeleteCongViec(
    EventDeleteCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    final currentState = state;

    if (currentState is StateCongViecByVMLoaded) {
      try {
        final success = await repository.deleteCongViec(event.id);
        if (success) {
          final updatedList =
              currentState.congViecs
                  .where((congViec) => congViec.id != event.id)
                  .toList();
          emit(StateCongViecDeleteSuccess());
          emit(
            StateCongViecByVMLoaded(
              congViecs: updatedList,
              groupId: currentState.groupId,
            ),
          );
        } else {
          emit(StateCongViecError('Xoá thất bại', errorTime: DateTime.now()));
          emit(currentState);
        }
      } catch (e) {
        emit(
          StateCongViecError(
            'Lỗi khi xoá: ${e.toString()}',
            errorTime: DateTime.now(),
          ),
        );
        emit(currentState);
      }
    }
  }

  Future<void> _onRefreshCongViec(
    EventRefreshCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    if (state is StateCongViecLoaded) {
      final currentState = state as StateCongViecLoaded;
      try {
        emit(StateCongViecLoading());
        final congViecs = await repository.fetchCongViec(
          groupId: currentState.congViecs.first.groupId,
          nguoiThucHien: currentState.congViecs.first.nguoiThucHien,
        );
        emit(
          StateCongViecLoaded(
            congViecs: congViecs,
            lastUpdated: DateTime.now(),
          ),
        );
      } catch (e) {
        emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetCongViecByVM(
    EventGetCongViecByVM event,
    Emitter<CongViecState> emit,
  ) async {
    emit(StateCongViecLoading());
    try {
      final congViecs = await repository.getCongViecByVM(event.congViec);
      emit(
        StateCongViecByVMLoaded(
          congViecs: congViecs,
          groupId: event.congViec.groupId,
        ),
      );
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetCongViecById(
    EventGetCongViecById event,
    Emitter<CongViecState> emit,
  ) async {
    emit(StateCongViecLoading());
    try {
      final congViec = await repository.getCongViecById(event.id);
      emit(StateCongViecByIdLoaded(congViec));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetAllNVTH(
    EventGetAllNVTH event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final nvths = await repository.getAllNVTH(event.groupId, event.nvths);
      emit(StateGetAllNVTHLoaded(nvths: nvths, groupId: event.groupId));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onUploadFile(
    EventUploadFile event,
    Emitter<CongViecState> emit,
  ) async {
    emit(StateCongViecLoading());
    try {
      final url = await repository.uploadFile(
        event.file,
      ); // trả về url từ server
      emit(StateUploadFile(event.file, url!));
    } catch (e) {
      emit(
        StateCongViecError(
          "Upload thất bại: ${e.toString()}",
          errorTime: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _onLoadAllCVC(
    EventLoadAllCVC event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final congViecs = await repository.loadAllCVC();
      emit(StateLoadCVC(congViecs));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onLoadCVCByIdCV(
    EventLoadCVCByIdCV event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final cvcRepository = await repository.loadCVCByIdCV(event.idCongViec);
      emit(StateLoadCVCByIdCV(cvcRepository));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onInsertCVC(
    EventInsertCVC event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final result = await repository.insertCVC(event.cvc);
      emit(StateInsertCVC(result));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onUpdateCVC(
    EventUpdateCVC event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final result = await repository.updateCVC(event.cvc);
      emit(StateUpdateCVC(result));
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onDeleteCVC(
    EventDeleteCVC event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final result = await repository.deleteCVC(event.id, event.userName);
      if(result){
        emit(StateDeleteCVC());
      }else{
        emit(StateCongViecError("Lỗi", errorTime: DateTime.now()));
      }
      
    } catch (e) {
      emit(StateCongViecError(e.toString(), errorTime: DateTime.now()));
    }
  }

  @override
  Future<void> close() {
    _congViecSubscription?.cancel();
    return super.close();
  }
}
