

import 'package:equatable/equatable.dart';

abstract class ReportNVTHEvent extends Equatable {
  const ReportNVTHEvent();

  @override
  List<Object> get props => [];
}

class FetchReportNVTH extends ReportNVTHEvent {
  final String groupId;
  final String taiKhoan;

  const FetchReportNVTH({
    required this.groupId,
    required this.taiKhoan,
  });

  @override
  List<Object> get props => [groupId, taiKhoan];
}
