import 'package:equatable/equatable.dart';

abstract class StatusReportEvent extends Equatable {
  const StatusReportEvent();
  @override
  List<Object> get props => [];
}

class FetchStatusReport extends StatusReportEvent {
  final String groupId;
  final String idNguoiGiaoViec;
  const FetchStatusReport({required this.groupId, required this.idNguoiGiaoViec});
  @override
  List<Object> get props => [groupId, idNguoiGiaoViec];
}
