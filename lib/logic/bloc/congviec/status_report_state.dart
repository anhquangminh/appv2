import 'package:ducanherp/data/models/status_report_model.dart';
import 'package:equatable/equatable.dart';

abstract class StatusReportState extends Equatable {
  const StatusReportState();
  @override
  List<Object?> get props => [];
}

class StatusReportInitial extends StatusReportState {}
class StatusReportLoading extends StatusReportState {}
class StatusReportLoaded extends StatusReportState {
  final StatusReportModel report;
  const StatusReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}
class StatusReportError extends StatusReportState {
  final String message;
  const StatusReportError(this.message);
  @override
  List<Object?> get props => [message];
}
