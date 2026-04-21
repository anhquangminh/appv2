import 'package:equatable/equatable.dart';

abstract class GroupReportEvent extends Equatable {
  const GroupReportEvent();
  @override
  List<Object> get props => [];
}

class FetchGroupReport extends GroupReportEvent {
  final String groupId;
  final String idNguoiGiaoViec;
  const FetchGroupReport({required this.groupId, required this.idNguoiGiaoViec});
  @override
  List<Object> get props => [groupId, idNguoiGiaoViec];
}
