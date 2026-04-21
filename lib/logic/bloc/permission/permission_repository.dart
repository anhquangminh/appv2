import 'dart:convert';
import 'package:ducanherp/data/models/permission_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/api_response_model.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class PermissionRepository {
  final SharedPreferences prefs;
  final http.Client client;

  PermissionRepository({required this.prefs, required this.client});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<PermissionModel>> getPermissions({
    required String groupId,
    required String userId,
    String? parentMajorId,
    String? majorId,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final queryParams = {
      'groupId': groupId,
      'userId': userId,
      if (parentMajorId != null && parentMajorId.isNotEmpty) 'parentMajorId': parentMajorId,
      if (majorId != null && majorId.isNotEmpty) 'majorId': majorId,
    };

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/phanquyen/GetAllPermissionByGroupId')
        .replace(queryParameters: queryParams);

    try {
      final response = await client.get(
        uri,
        headers: _buildHeaders(token),
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<List<PermissionModel>> loadPermissionsFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('permissions');
      if (jsonList == null) return [];

      return jsonList
          .map((e) => PermissionModel.fromJson(jsonDecode(e)))
          .toList();
    } catch (e) {
      handleNetworkException(e);

    }
  }

  List<PermissionModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => PermissionModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}