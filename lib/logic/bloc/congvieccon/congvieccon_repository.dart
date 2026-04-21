// lib/logic/bloc/congvieccon/congvieccon_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ducanherp/data/models/congvieccon_model.dart';

class CongViecConRepository {
  final Dio _dio;

  CongViecConRepository(this._dio);

  Future<List<CongViecConModel>> getByCongViecId(String congViecId) async {
    final response = await _dio.get(
      '${dotenv.env['API_URL']}/api/congviec/GetByIdCongViecCVC/$congViecId',
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => CongViecConModel.fromJson(e))
          .toList();
    }

    throw Exception(response.statusMessage);
  }
}
