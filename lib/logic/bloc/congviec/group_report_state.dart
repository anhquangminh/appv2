import 'package:ducanherp/data/models/group_report_model.dart';
import 'package:equatable/equatable.dart';

abstract class GroupReportState extends Equatable {
  const GroupReportState();
  @override
  List<Object?> get props => [];
}

class GroupReportInitial extends GroupReportState {}
class GroupReportLoading extends GroupReportState {}
class GroupReportLoaded extends GroupReportState {
  final List<GroupReportModel> groups;
  const GroupReportLoaded(this.groups);
  @override
  List<Object?> get props => [groups];
}
class GroupReportError extends GroupReportState {
  final String message;
  const GroupReportError(this.message);
  @override
  List<Object?> get props => [message];
}
