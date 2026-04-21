import 'dart:convert';
import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:ducanherp/data/models/danhgia_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class DanhGiaRepository {
  final SharedPreferences prefs;

  DanhGiaRepository(this.prefs);

  Future<Map<String, String>> _buildHeaders() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<DanhGiaModel> getByIdCongViec(String idCongViec) async {
    try {
      final String baseUrl = dotenv.env['API_URL']!;
      final uri = Uri.parse(
        '$baseUrl/api/danhgia/GetByIdCongViec?idCongViec=$idCongViec',
      );
      final headers = await _buildHeaders();

      final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 15));
      return await _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<DanhGiaModel> create(DanhGiaModel model, String userName) async {
    try {
      final String baseUrl = dotenv.env['API_URL']!;
      final uri = Uri.parse('$baseUrl/api/danhgia?userName=$userName');

      final headers = await _buildHeaders();
      final request = http.Request('POST', uri)
        ..headers.addAll(headers)
        ..body = jsonEncode(model.toJson());

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);
      return await _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<DanhGiaModel> update(DanhGiaModel model, String userName) async {
    try {
      final String baseUrl = dotenv.env['API_URL']!;
      final uri = Uri.parse(
        '$baseUrl/api/danhgia/${model.id}?userName=$userName',
      );

      final headers = await _buildHeaders();
      final request = http.Request('PUT', uri)
        ..headers.addAll(headers)
        ..body = jsonEncode(model.toJson());
      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);
      return await _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<DanhGiaModel> getById(String id) async {
    try {
      final String baseUrl = dotenv.env['API_URL']!;
      final uri = Uri.parse('$baseUrl/api/danhgia/$id');

      final headers = await _buildHeaders();
      final request = http.Request('GET', uri)..headers.addAll(headers);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);
      return await _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<DanhGiaModel> _handleResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return DanhGiaModel.fromJson(apiResponse.data);
      }
      throw Exception(apiResponse.message);
    }
    
    if (response.statusCode == 400) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}