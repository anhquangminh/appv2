import 'package:equatable/equatable.dart';

abstract class CongViecConEvent extends Equatable {
  const CongViecConEvent();

  @override
  List<Object?> get props => [];
}

class GetCongViecConByCongViecId extends CongViecConEvent {
  final String congViecId;

  const GetCongViecConByCongViecId(this.congViecId);

  @override
  List<Object?> get props => [congViecId];
}
