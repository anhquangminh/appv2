import 'package:ducanherp/data/models/chuyenmon_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChuyenMonEvent extends Equatable {
  const ChuyenMonEvent();
  @override
  List<Object?> get props => [];
}

class FetchChuyenMon extends ChuyenMonEvent {
  final ChuyenMonModel filter;
  const FetchChuyenMon(this.filter);
  @override
  List<Object?> get props => [filter];
}
