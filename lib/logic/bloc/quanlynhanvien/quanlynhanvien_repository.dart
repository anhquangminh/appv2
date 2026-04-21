import 'dart:convert';
import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/repositories/api_response_model.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class QuanLyNhanVienRepository {
  final http.Client client;
  final SharedPreferences prefs;

  QuanLyNhanVienRepository({required this.client, required this.prefs});

  Future<List<QuanLyNhanVienModel>> fetchQuanLyNhanVien({
    required String groupId,
    required String taiKhoan,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/QuanLyNhanVien/GetQuanLyNhanVienByTaiKhoanAsync?groupId=$groupId&taiKhoan=$taiKhoan',
    );
    try {
      final response = await client
          .get(uri, headers: _buildHeaders(token))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<QuanLyNhanVienModel> addQuanLyNhanVien(
    QuanLyNhanVienModel model,
    String userName,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final url = Uri.parse(
      '${dotenv.env['API_URL']}/api/QuanLyNhanVien?userName=$userName',
    );
    final body = jsonEncode(model);

    try {
      final request =
          http.Request('POST', url)
            ..headers.addAll(_buildHeaders(token))
            ..body = body;

      final response = await http.Response.fromStream(
        await request.send().timeout(const Duration(seconds: 15)),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return model;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception(
          'Lỗi hệ thống: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<QuanLyNhanVienModel> updateQuanLyNhanVien(
    QuanLyNhanVienModel model,
    String userName,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final url = Uri.parse(
      '${dotenv.env['API_URL']}/api/QuanLyNhanVien/${model.id}?userName=$userName',
    );
    final headers = _buildHeaders(token);
    final body = jsonEncode(model);

    try {
      final request =
          http.Request('PUT', url)
            ..headers.addAll(headers)
            ..body = body;

      final response = await http.Response.fromStream(
        await request.send().timeout(const Duration(seconds: 15)),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return model;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception(
          'Lỗi hệ thống: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Future<void> deleteQuanLyNhanVien(String id, String userName) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final url = Uri.parse(
      '${dotenv.env['API_URL']}/api/QuanLyNhanVien/$id?userName=$userName',
    );

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final request = http.Request('DELETE', url)..headers.addAll(headers);

      final response = await http.Response.fromStream(
        await request.send().timeout(const Duration(seconds: 15)),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (!apiResponse.success) {
          throw Exception(
            'Lỗi xoá nhân viên trong nhóm:- ${apiResponse.message}',
          );
        }
      }
    } catch (e) {
      handleNetworkException(e);
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  List<QuanLyNhanVienModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => QuanLyNhanVienModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }

  Future<List<QuanLyNhanVienModel>> getQuanLyNhanVienByVM(
    QuanLyNhanVienModel nhomNhanVien,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = _buildHeaders(token);

    try {
      final request = http.Request(
        'POST',
        Uri.parse(
          '${dotenv.env['API_URL']}/api/QuanLyNhanVien/GetByVM?groupId=${nhomNhanVien.groupId}',
        ),
      );
      request.body = json.encode(nhomNhanVien.toJson());
      request.headers.addAll(headers);

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
      );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
    }
  }

  // Mở: Duyệt nhóm nhân viên theo id
  Future<bool> duyetQuanLyNhanVien(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri =  Uri.parse(
      '${dotenv.env['API_URL']}/api/QuanLyNhanVien/Duyet?id=$id',
    );
    final headers = _buildHeaders(token);

    try {
      final response = await client
          .post(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return true;
        } else {
          throw Exception(apiResponse.message);
        }
      }
      throw Exception('Lỗi server: ${response.statusCode}');
    } catch (e) {
      handleNetworkException(e);
    }
  }

  // Mở: Hủy duyệt (huỷ duyệt) nhóm nhân viên theo id
  Future<bool> huyDuyetQuanLyNhanVien(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/QuanLyNhanVien/HuyDuyet?id=$id',
    );
    final headers = _buildHeaders(token);

    try {
      final response = await client
          .post(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return true;
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
