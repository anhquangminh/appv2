import 'package:equatable/equatable.dart';

abstract class ChiNhanhEvent extends Equatable {
  const ChiNhanhEvent();

  @override
  List<Object> get props => [];
}

class FetchChiNhanh extends ChiNhanhEvent {
  final String groupId;

  const FetchChiNhanh({required this.groupId});

  @override
  List<Object> get props => [groupId];
}
