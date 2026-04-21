import 'package:bloc/bloc.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_event.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_repository.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_state.dart';

class ReportNVTHBloc
    extends Bloc<ReportNVTHEvent, ReportNVTHState> {
  final ReportNVTHRepository repository;

  ReportNVTHBloc({required this.repository})
      : super(ReportNVTHInitial()) {
    on<FetchReportNVTH>(_onFetchReportNVTH);
  }

  Future<void> _onFetchReportNVTH(
    FetchReportNVTH event,
    Emitter<ReportNVTHState> emit,
  ) async {
    emit(ReportNVTHLoading());
    try {
      final data = await repository.fetchReportNVTH(
        groupId: event.groupId,
        taiKhoan: event.taiKhoan,
      );
      emit(ReportNVTHLoaded(data));
    } catch (e) {
      emit(ReportNVTHError(e.toString()));
    }
  }
}
