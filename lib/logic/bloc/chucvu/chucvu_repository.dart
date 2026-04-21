import 'dart:async';
import 'dart:convert';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';
import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/chucvu_model.dart'; // Bạn cần tạo model này nếu chưa có

class ChucVuRepository {
  final http.Client client;
  final SharedPreferences prefs;

  ChucVuRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<ChucVuModel>> getChucVuByVM(ChucVuModel chucVuModel) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/NhanSu/ChucVuGetAllByVM?groupId=${chucVuModel.groupId}',
    );

    try {
      final response = await client
          .post(
            uri,
            headers: _buildHeaders(token),
            body: jsonEncode(chucVuModel),
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  List<ChucVuModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => ChucVuModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
