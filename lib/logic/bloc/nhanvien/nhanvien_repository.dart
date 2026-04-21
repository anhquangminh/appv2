import 'dart:convert';
import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/nhanvien_model.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class NhanVienRepository {
  final http.Client client;
  final SharedPreferences prefs;

  NhanVienRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<NhanVienModel>> fetchNhanVien({
    required String groupId,
    required String taiKhoan,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien?groupId=$groupId&taiKhoan=$taiKhoan');
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

  Future<NhanVienModel> addNhanVien(NhanVienModel nhanVien, String userName) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final url = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien?userName=$userName');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = jsonEncode(nhanVien.toJson());

      final response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 15)));

      if (response.statusCode == 200 || response.statusCode == 400) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return NhanVienModel.fromJson(apiResponse.data);
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Lỗi hệ thống: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<NhanVienModel> updateNhanVien(NhanVienModel nhanVien, String userName) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final url = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/${nhanVien.id}?userName=$userName');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request('PUT', url)
        ..headers.addAll(headers)
        ..body = jsonEncode(nhanVien.toJson());

      final response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 15)));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return NhanVienModel.fromJson(apiResponse.data);
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Lỗi hệ thống: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<void> deleteNhanVien(String id, String userName) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final url = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/$id?userName=$userName');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request('DELETE', url)
        ..headers.addAll(headers);

      final response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 15)));

      if (response.statusCode != 200) {
        throw Exception('Lỗi xoá nhân viên: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<NhanVienModel>> getNhanVienByVM(NhanVienModel nhanVien) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/GetByVM?groupId=${nhanVien.groupId}');
    try {
      final response = await client.post(
        uri,
        headers: _buildHeaders(token),
        body: json.encode(nhanVien.toJson()),
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<NhanVienModel>> GetNhanVienByNhom({
    required String groupId,
    required String idNhomNhanVien,
    required String companyId,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/GetNhanVienByNhom?groupId=$groupId&companyId=$companyId&Id_NhomNhanVien=$idNhomNhanVien');
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

  // Mở: Duyệt  nhân viên theo id
  Future<bool> duyetNhanVien(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/Duyet?id=$id');
    final headers = _buildHeaders(token);

    try {
      final response = await client.post(uri, headers: headers).timeout(const Duration(seconds: 15));

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

  // Mở: Hủy duyệt (huỷ duyệt) nhân viên theo id
  Future<bool> huyDuyetNhanVien(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/HuyDuyet?id=$id');
    final headers = _buildHeaders(token);

    try {
      final response = await client.post(uri, headers: headers).timeout(const Duration(seconds: 15));

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