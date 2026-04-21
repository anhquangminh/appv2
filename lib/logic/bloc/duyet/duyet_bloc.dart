import 'package:flutter_bloc/flutter_bloc.dart';
import 'duyet_event.dart';
import 'duyet_state.dart';
import 'duyet_repository.dart';

class DuyetBloc extends Bloc<EventDuyet, StateDuyet> {
  final DuyetRepository repository;

  DuyetBloc({required this.repository}) : super(StateDuyetInitial()) {
    on<EventDuyetRequest>(_onDuyetRequest);
    on<EventHuyDuyetRequest>(_onHuyDuyetRequest);
    on<EventGetAwaitingApprovalTasks>(_onGetAwaitingApprovalTasks);
    on<EventGetApprovalByUserIdTasks>(_onGetApprovalByUserIdTasks);
    on<EventGetDuyetByVM>(_onGetDuyetByVM);
    on<EventGetAllParentMajors>(_onGetAllParentMajors);
    on<EventGetAllMajorByParentId>(_onGetAllMajorByParentId);
  }

  Future<void> _onDuyetRequest(
    EventDuyetRequest event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      await repository.duyet(event.id);
      // emit(const StateDuyetSuccess('Duyệt thành công'));
      emit(
        StateDuyetSuccess(
          message: "Duyệt thành công",
          id: event.id,
          isApprove: true,
        ),
      );
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onHuyDuyetRequest(
    EventHuyDuyetRequest event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      await repository.huyDuyet(event.id);
      // emit(const StateDuyetSuccess('Hủy duyệt thành công'));
      emit(
        StateDuyetSuccess(
          message: "Hủy duyệt thành công",
          id: event.id,
          isApprove: false,
        ),
      );
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetAwaitingApprovalTasks(
    EventGetAwaitingApprovalTasks event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      final result = await repository.getAwaitingApprovalTasks(
        groupId: event.groupId,
        userId: event.userId,
        currentPage: event.currentPage,
        pageSize: event.pageSize,
        parentMajorId: event.parentMajorId,
        majorId: event.majorId,
      );

      emit(
        StateAwaitingApprovalTasksLoaded(
          tasks: result['tasks'],
          totalCount: result['totalCount'],
        ),
      );
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetApprovalByUserIdTasks(
    EventGetApprovalByUserIdTasks event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      final result = await repository.getApprovalByUserIdTasks(
        groupId: event.groupId,
        userId: event.userId,
        currentPage: event.currentPage,
        pageSize: event.pageSize,
        parentMajorId: event.parentMajorId,
        majorId: event.majorId,
      );

      emit(
        StateApprovalByUserIdTasksLoaded(
          tasks: result['tasks'],
          totalCount: result['totalCount'],
        ),
      );
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetDuyetByVM(
    EventGetDuyetByVM event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      final duyets = await repository.getDuyetByVM(
        groupId: event.groupId,
        filter: event.filter,
        currentPage: event.currentPage,
        pageSize: event.pageSize,
      );
      emit(StateDuyetByVMLoaded(duyets: duyets, groupId: event.groupId));
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetAllParentMajors(
    EventGetAllParentMajors event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      final parentMajors = await repository.getAllParentMajors(event.groupId);
      emit(StateParentMajorsLoaded(parentMajors: parentMajors));
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }

  Future<void> _onGetAllMajorByParentId(
    EventGetAllMajorByParentId event,
    Emitter<StateDuyet> emit,
  ) async {
    emit(StateDuyetLoading());
    try {
      final majors = await repository.getAllMajorByParentId(
        event.groupId,
        event.parentId,
      );
      emit(StateMajorsByParentLoaded(majors: majors, parentId: event.parentId));
    } catch (e) {
      emit(StateDuyetError(e.toString(), errorTime: DateTime.now()));
    }
  }
}
