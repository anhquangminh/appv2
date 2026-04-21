import 'package:ducanherp/data/models/chucvu_model.dart';

abstract class ChucVuEvent {}

class FetchChucVu extends ChucVuEvent {
  final ChucVuModel chucVuModel;

  FetchChucVu(this.chucVuModel);
}
