import 'dart:convert';
import 'package:ducanherp/data/models/duyet_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/helpers/network_exception_helper.dart';
import '../../../data/repositories/api_response_model.dart';

class DuyetRepository {
  final http.Client client;
  final SharedPreferences prefs;

  DuyetRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> duyet(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/duyet/Duyet?id=$id');
    final headers = _buildHeaders(token);

    try {
      final response = await client
          .post(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);
        return apiResponse.success;
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<bool> huyDuyet(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/duyet/HuyDuyet?id=$id');
    final headers = _buildHeaders(token);

    try {
      final response = await client
          .post(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);
        return apiResponse.success;
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<Map<String, dynamic>> getAwaitingApprovalTasks({
    required String groupId,
    required String userId,
    int currentPage = 0,
    int pageSize = 20,
    String parentMajorId = "",
    String majorId = "",
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final queryParams = {
      'groupId': groupId,
      'userId': userId,
      'currentPage': currentPage.toString(),
      'pageSize': pageSize.toString(),
    };

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/duyet/GetAwaitingApprovalTasks',
    ).replace(queryParameters: queryParams);

    final headers = _buildHeaders(token);

    try {
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          final data = apiResponse.data as List;
          final tasks = data.map((item) => DuyetModel.fromJson(item)).toList();
          return {
            'tasks': tasks,
            'totalCount': data.length,
          };
        } else {
          throw Exception(apiResponse.message);
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<Map<String, dynamic>> getApprovalByUserIdTasks({
    required String groupId,
    required String userId,
    int currentPage = 0,
    int pageSize = 20,
    String parentMajorId = "",
    String majorId = "",
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final queryParams = {
      'groupId': groupId,
      'userId': userId,
      'currentPage': currentPage.toString(),
      'pageSize': pageSize.toString(),
    };

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/duyet/GetApprovalByUserIdTasks',
    ).replace(queryParameters: queryParams);

    final headers = _buildHeaders(token);

    try {
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          final data = apiResponse.data as List;
          final tasks = data.map((item) => DuyetModel.fromJson(item)).toList();
          return {
            'tasks': tasks,
            'totalCount': data.length,
          };
        } else {
          throw Exception(apiResponse.message);
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<List<DuyetModel>> getDuyetByVM({
    required String groupId,
    required DuyetModel filter,
    int currentPage = 0,
    int pageSize = 20,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/duyet/GetByVM').replace(
      queryParameters: {
        'groupId': groupId,
        'currentPage': currentPage.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final headers = _buildHeaders(token);

    try {
      final response = await client
          .post(uri, headers: headers, body: json.encode(filter.toJson()))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          final data = apiResponse.data as List;
          return data.map((item) => DuyetModel.fromJson(item)).toList();
        } else {
          throw Exception(apiResponse.message);
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }
  Future<List<String>> getAllParentMajors(String groupId) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/duyet/GetAllParentMajors',
    ).replace(queryParameters: {'groupId': groupId});

    final headers = _buildHeaders(token);

    try {
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return List<String>.from(apiResponse.data);
        } else {
          throw Exception(apiResponse.message);
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<List<String>> getAllMajorByParentId(
    String groupId,
    String parentId,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/duyet/GetAllMajorByParentId',
    ).replace(queryParameters: {'groupId': groupId, 'parentId': parentId});

    final headers = _buildHeaders(token);

    try {
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return List<String>.from(apiResponse.data);
        } else {
          throw Exception(apiResponse.message);
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }
}