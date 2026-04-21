// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:ducanherp/data/models/report_nvth_model.dart';

abstract class ReportNVTHState extends Equatable {
  const ReportNVTHState();

  @override
  List<Object?> get props => [];
}

class ReportNVTHInitial extends ReportNVTHState {}

class ReportNVTHLoading extends ReportNVTHState {}

class ReportNVTHLoaded extends ReportNVTHState {
  final ReportNVTHModel data;

  const ReportNVTHLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ReportNVTHError extends ReportNVTHState {
  final String message;

  const ReportNVTHError(this.message);

  @override
  List<Object?> get props => [message];
}
