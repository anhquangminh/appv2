import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ducanherp/logic/bloc/congviecdg/congviecdg_event.dart';
import 'package:ducanherp/logic/bloc/congviecdg/congviecdg_repository.dart';
import 'package:ducanherp/logic/bloc/congviecdg/congviecdg_state.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CongViecDGBloc extends Bloc<CongViecDGEvent, CongViecDGState> {
  final http.Client client;
  final SharedPreferences prefs;
  late final CongViecDGRepository repository;
  StreamSubscription? _congViecSubscription;

  CongViecDGBloc({required this.client, required this.prefs})
    : repository = CongViecDGRepository(client: client, prefs: prefs),
      super(CongViecDGInitial()) {
    on<LoadCongViecDG>(_onLoadCongViecDG);
    on<AddCongViecDG>(_onAddCongViecDG);
    on<UpdateCongViecDGEvent>(_onUpdateCongViecDG);
    on<DeleteCongViecDG>(_onDeleteCongViecDG);
    on<RefreshCongViecDG>(_onRefreshCongViecDG);
    on<GetCongViecDGByVM>(_onGetCongViecDGByVM);
    on<GetAllNVTHDG>(_onGetAllNVTHDG);
    on<UploadFileEventDG>(_onUploadFileDG);
    on<LoadCVCByIdCVEventDG>(_onLoadCVCByIdCVDG);
    on<UpdateCVCEventDG>(_onUpdateCVCDG);
    on<InsertCVCEventDG>(_onInsertCVCDG);
    on<LoadAllCVCEventDG>(_onLoadAllCVCDG);
    on<DeleteCVCEventDG>(_onDeleteCVCDG);
  }

  Future<void> _onLoadCongViecDG(
    LoadCongViecDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    emit(CongViecDGLoading());
    try {
      final congViecs = await repository.fetchCongViec(
        groupId: event.groupId,
        nguoiThucHien: event.nguoiThucHien,
      );
      emit(CongViecDGLoaded(congViecs: congViecs, lastUpdated: DateTime.now()));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onAddCongViecDG(
    AddCongViecDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    final currentState = state;

    emit(CongViecDGLoading());

    try {
      final newCongViecDG = await repository.addCongViec(
        event.congViec,
        event.themNgay,
        event.nhanViens,
      );
      emit(CongViecDGInsertSuccess());
      // Nếu trước đó là CongViecDGLoaded thì thêm vào danh sách cũ
      if (currentState is CongViecDGLoaded) {
        emit(
          CongViecDGLoaded(
            congViecs: [...currentState.congViecs, newCongViecDG],
            lastUpdated: DateTime.now(),
          ),
        );
      } else {
        // Nếu chưa có data thì tạo mới danh sách
        emit(
          CongViecDGLoaded(congViecs: [newCongViecDG], lastUpdated: DateTime.now()),
        );
      }
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));

      // Optional: giữ lại state cũ nếu có
      if (currentState is CongViecDGLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateCongViecDG(
    UpdateCongViecDGEvent event,
    Emitter<CongViecDGState> emit,
  ) async {
    emit(CongViecDGLoading());

    try {
      final updated = await repository.updateCongViec(
        event.congViec,
        event.themNgay,
        event.nhanViens,
      );
      emit(CongViecDGUpdatedDG(updated));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onDeleteCongViecDG(
    DeleteCongViecDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    final currentState = state;

    if (currentState is CongViecDGByVMLoaded) {
      try {
        final success = await repository.deleteCongViec(event.id);
        if (success) {
          final updatedList =
              currentState.congViecs
                  .where((congViec) => congViec.id != event.id)
                  .toList();
          emit(CongViecDGDeleteSuccess());
          emit(
            CongViecDGByVMLoaded(
              congViecs: updatedList,
              groupId: currentState.groupId,
            ),
          );
        } else {
          emit(CongViecDGError('Xoá thất bại', errorTime: DateTime.now()));
          emit(currentState);
        }
      } catch (e) {
        emit(
          CongViecDGError(
            'Lỗi khi xoá: ${e.toString()}',
            errorTime: DateTime.now(),
          ),
        );
        emit(currentState);
      }
    }
  }

  Future<void> _onRefreshCongViecDG(
    RefreshCongViecDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    if (state is CongViecDGLoaded) {
      final currentState = state as CongViecDGLoaded;
      try {
        emit(CongViecDGLoading());
        final congViecs = await repository.fetchCongViec(
          groupId: currentState.congViecs.first.groupId,
          nguoiThucHien: currentState.congViecs.first.nguoiThucHien,
        );
        emit(CongViecDGLoaded(congViecs: congViecs, lastUpdated: DateTime.now()));
      } catch (e) {
        emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetCongViecDGByVM(
    GetCongViecDGByVM event,
    Emitter<CongViecDGState> emit,
  ) async {
    emit(CongViecDGLoading());
    try {
      final congViecs = await repository.getCongViecByVM(event.congViec);
      emit(
        CongViecDGByVMLoaded(
          congViecs: congViecs,
          groupId: event.congViec.groupId,
        ),
      );
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetAllNVTHDG(
    GetAllNVTHDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    try {
      final nvths = await repository.getAllNVTH(event.groupId, event.nvths);
      emit(GetAllNVTHLoadedDG(nvths: nvths, groupId: event.groupId));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onUploadFileDG(
    UploadFileEventDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    emit(CongViecDGLoading());
    try {
      final url = await repository.uploadFile(
        event.file,
      ); // trả về url từ server
      emit(UploadFileDG(event.file, url!));
    } catch (e) {
      emit(
        CongViecDGError(
          "Upload thất bại: ${e.toString()}",
          errorTime: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _onLoadAllCVCDG(
    LoadAllCVCEventDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    try {
      final congViecs = await repository.loadAllCVC();
      emit(LoadCVCStateDG(congViecs));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onLoadCVCByIdCVDG(
    LoadCVCByIdCVEventDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    try {
      final cvcRepository = await repository.loadCVCByIdCV(event.idCongViecDG);
      emit(LoadCVCByIdCVStateDG(cvcRepository));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onUpdateCVCDG(
    UpdateCVCEventDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    try {
      final cvcRepository = await repository.updateCVC(event.cvc);
      emit(UpdateCVCStateDG(cvcRepository));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onInsertCVCDG(
    InsertCVCEventDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    try {
      event.cvc.id = "";
      final cvcRepository = await repository.insertCVC(event.cvc);
      emit(InsertCVCStateDG(cvcRepository));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onDeleteCVCDG(
    DeleteCVCEventDG event,
    Emitter<CongViecDGState> emit,
  ) async {
    try {
      final cvcRepository = await repository.deleteCVC(
        event.id,
        event.userName,
      );
      emit(DeleteCVCStateDG(cvcRepository));
    } catch (e) {
      emit(CongViecDGError(e.toString(), errorTime: DateTime.now()));
    }
  }

  @override
  Future<void> close() {
    _congViecSubscription?.cancel();
    return super.close();
  }
}
