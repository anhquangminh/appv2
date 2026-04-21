import 'dart:convert';
import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:ducanherp/data/models/notification_model.dart';
import 'package:ducanherp/data/models/notificationfirebase_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class NotificationRepository {
  final http.Client client;
  final SharedPreferences prefs;

  NotificationRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> sendNotification({
    required List<String> userIds,
    required String title,
    required String body,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/send-notification');
    try {
      final response = await client.post(
        uri,
        headers: _buildHeaders(token),
        body: json.encode({'userIds': userIds, 'title': title, 'body': body}),
      );
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<String> registerToken({
    required String token,
    required String groupId,
    required String userId,
  }) async {
    final String? authToken = prefs.getString('token');
    if (authToken == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/register-token');
    try {
      final response = await client.post(
        uri,
        headers: _buildHeaders(authToken),
        body: json.encode({
          'token': token,
          'groupId': groupId,
          'userId': userId,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<String> unregisterToken({
    required String token,
    required String groupId,
    required String userId,
  }) async {
    final String? authToken = prefs.getString('token');
    if (authToken == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/unregister-token');
    try {
      final response = await client.post(
        uri,
        headers: _buildHeaders(authToken),
        body: json.encode({
          'token': token,
          'groupId': groupId,
          'userId': userId,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<NotificationModel> updateNotification({
    required NotificationModel notifi,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/Update');
    try {
      final response = await client.put(
        uri,
        headers: _buildHeaders(token),
        body: jsonEncode(notifi),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return NotificationModel.fromJson(apiResponse.data);
        }
        throw Exception(apiResponse.message);
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<List<NotificationModel>> getAllNotiByUser() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/GetAllNotiByUser?userName=${cachedUser?.id}',
    );
    try {
      final response = await client.get(uri, headers: _buildHeaders(token));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        }
        throw Exception(apiResponse.message);
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<List<NotificationModel>> getAllCategoriesByUser() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/GetAllCategoriesByUser?userName=${cachedUser?.id}',
    );
    try {
      final response = await client.get(uri, headers: _buildHeaders(token));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        }
        throw Exception(apiResponse.message);
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<List<NotificationModel>> getAllNotiByUserId(
    int currentPage,
    int pageSize,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/GetAllNotiByUserId?userId=${cachedUser?.id}&currentPage=$currentPage&pageSize=$pageSize',
    );
    try {
      final response = await client.get(uri, headers: _buildHeaders(token));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        }
        throw Exception(apiResponse.message);
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<int> getUnreadNotiByUserId() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/GetUnreadNotiByUserId?Id=${cachedUser?.id}',
    );
    try {
      final response = await client
          .get(uri, headers: _buildHeaders(token))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return apiResponse.data;
        } else {
          return 0;
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<List<NotificationFireBaseModel>> getAllNotiFireBaseByUserId(
    int currentPage,
    int pageSize,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/GetAllNotiFireBaseByUserId?reciverId=${cachedUser?.id}&currentPage=$currentPage&pageSize=$pageSize',
    );
    try {
      final response = await client
          .get(uri, headers: _buildHeaders(token))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => NotificationFireBaseModel.fromJson(e))
              .toList();
        }
        throw Exception(apiResponse.message);
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<int> getUnreadNotiFireBaseByUserId() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/GetUnreadNotiFireBaseByUserId?Id=${cachedUser?.id}',
    );
    try {
      final response = await client
          .get(uri, headers: _buildHeaders(token))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return apiResponse.data;
        } else {
          return 0;
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);

    }
  }

  Future<bool> isReadFireBaseId({required String id}) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/fcm/IsReadFireBaseId?id=$id',
    );
    try {
      final response = await client
          .put(uri, headers: _buildHeaders(token))
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

  String _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return apiResponse.message;
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
