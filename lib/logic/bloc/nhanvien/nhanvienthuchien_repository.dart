
import 'dart:convert';
import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class NhanVienThucHienRepository {
  final http.Client client;
  final SharedPreferences prefs;

  NhanVienThucHienRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<NhanVienModel>> fetchNhanViensByCongViec(String congViecId, String groupId) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/nhanvienthuchien/NhanViensByCongViec?id_CongViec=$congViecId&groupId=$groupId');
    try {
      final response = await client.get(
        uri,
        headers: _buildHeaders(token),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return _handleResponse(response);
      } else {
        throw Exception('Failed to load NhanViens: ${response.statusCode}');
      }
    } catch (e) {
      handleNetworkException(e);
    }
  }
  List<NhanVienModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => NhanVienModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}