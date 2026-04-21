import 'package:bloc/bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_event.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_state.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_repository.dart';

class GroupReportBloc extends Bloc<GroupReportEvent, GroupReportState> {
  final GroupReportRepository repository;
  GroupReportBloc({required this.repository}) : super(GroupReportInitial()) {
    on<FetchGroupReport>(_onFetchGroupReport);
  }

  Future<void> _onFetchGroupReport(
    FetchGroupReport event,
    Emitter<GroupReportState> emit,
  ) async {
    emit(GroupReportLoading());
    try {
      final groups = await repository.fetchGroupReport(
        groupId: event.groupId,
        idNguoiGiaoViec: event.idNguoiGiaoViec,
      );
      emit(GroupReportLoaded(groups));
    } catch (e) {
      emit(GroupReportError(e.toString()));
    }
  }
}
