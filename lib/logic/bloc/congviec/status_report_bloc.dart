import 'package:bloc/bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_event.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_state.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_repository.dart';

class StatusReportBloc extends Bloc<StatusReportEvent, StatusReportState> {
  final StatusReportRepository repository;
  StatusReportBloc({required this.repository}) : super(StatusReportInitial()) {
    on<FetchStatusReport>(_onFetchStatusReport);
  }

  Future<void> _onFetchStatusReport(
    FetchStatusReport event,
    Emitter<StatusReportState> emit,
  ) async {
    emit(StatusReportLoading());
    try {
      final report = await repository.fetchStatusReport(
        groupId: event.groupId,
        idNguoiGiaoViec: event.idNguoiGiaoViec,
      );
      emit(StatusReportLoaded(report));
    } catch (e) {
      emit(StatusReportError(e.toString()));
    }
  }
}
