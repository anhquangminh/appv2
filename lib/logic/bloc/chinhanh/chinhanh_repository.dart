import 'dart:async';
import 'dart:convert';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';
import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:ducanherp/data/models/chinhanh_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChiNhanhRepository {
  final http.Client client;
  final SharedPreferences prefs;

  ChiNhanhRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<ChiNhanhModel>> fetchChiNhanh({required String groupId}) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/chinhanh/getall?groupId=$groupId',
    );

    try {
      final response = await client
          .get(uri, headers: _buildHeaders(token))
          .timeout(const Duration(seconds: 15));
      return _handleListResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  List<ChiNhanhModel> _handleListResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => ChiNhanhModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    } else {
      throw Exception(
        'Lỗi server: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  }
}
