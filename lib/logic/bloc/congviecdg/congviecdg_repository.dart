
import 'dart:convert';
import 'dart:io';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';
import 'package:ducanherp/data/models/congvieccon_model.dart';
import 'package:ducanherp/data/models/nhanvienthuchien_model.dart';
import 'package:ducanherp/data/models/themngay_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/models/congviec_model.dart';
import '../../../data/repositories/api_response_model.dart';

class CongViecDGRepository {
  final http.Client client;
  final SharedPreferences prefs;

  CongViecDGRepository({required this.client, required this.prefs});

  Future<List<CongViecModel>> fetchCongViec({
    required String groupId,
    required String nguoiThucHien,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/CongViec/GetByVM?groupId=$groupId',
    );

    try {
      final response = await client.post(
        uri,
        headers: _buildHeaders(token),
        body: json.encode({"NguoiThucHien": nguoiThucHien, "GroupId": groupId}),
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<CongViecModel> addCongViec(
    CongViecModel congViec,
    ThemNgayModel themNgay,
    List<String> nhanVien,
  ) async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/api/CongViec/CreateCongViec',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString("token")}',
    };

    final body = {
      "congViec": congViec.toJson(),
      "nhanVienThucHien": nhanVien,
      "themNgay": themNgay.toJson(),
    };

    try {
      final request =
          http.Request('POST', url)
            ..headers.addAll(headers)
            ..body = jsonEncode(body);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500 ||
          response.statusCode == 404 ||
          response.statusCode == 302) {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return CongViecModel.fromJson(apiResponse.data);
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final realFile = File(file.path!);
      final url = Uri.parse('${dotenv.env['API_URL']}/api/CongViec/upload');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("token")}',
      };

      final request =
          http.MultipartRequest('POST', url)
            ..headers.addAll(headers)
            ..files.add(
              await http.MultipartFile.fromPath('file', realFile.path),
            );

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500 ||
          response.statusCode == 404 ||
          response.statusCode == 302) {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return apiResponse.data;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<CongViecModel> updateCongViec(
    CongViecModel congViec,
    ThemNgayModel themNgay,
    List<String> nhanVien,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['API_URL']}/api/CongViec/UpdateCongViec?id=${congViec.id}',
      );

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("token")}',
      };

      final body = {
        "congViec": congViec.toJson(),
        "nhanVienThucHien": nhanVien,
        "themNgay": themNgay.toJson(),
      };

      final request =
          http.Request('PUT', url)
            ..headers.addAll(headers)
            ..body = jsonEncode(body);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Lỗi: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return CongViecModel.fromJson(apiResponse.data);
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<bool> deleteCongViec(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/CongViec/$id?userName=${prefs.getString('userName')}',
    );
    try {
      final response = await client.delete(uri, headers: _buildHeaders(token)).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 500 || response.statusCode == 404) {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return true;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<CongViecModel>> getCongViecByVM(CongViecModel congViec) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request(
        'POST',
        Uri.parse(
          '${dotenv.env['API_URL']}/api/CongViec/GetByVM?groupId=${congViec.groupId}',
        ),
      );
      request.body = json.encode(congViec.toJson());
      request.headers.addAll(headers);

      final response = await client.send(request).timeout(const Duration(seconds: 15));
      final responseBody = await http.Response.fromStream(response);

      return _handleResponse(responseBody);
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<NhanVienThucHienModel>> getAllNVTH(
    String groupId,
    NhanVienThucHienModel nvth,
  ) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request(
        'GET',
        Uri.parse(
          '${dotenv.env['API_URL']}/api/congviec/GetAllNVTH?groupId=$groupId',
        ),
      );

      request.body = json.encode(nvth.toJson());
      request.headers.addAll(headers);

      final response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => NhanVienThucHienModel.fromJson(e))
              .toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<CongViecConModel>> loadAllCVC() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request(
        'GET',
        Uri.parse('${dotenv.env['API_URL']}/api/congviec/GetAllCVC'),
      );
      request.headers.addAll(headers);

      final response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => CongViecConModel.fromJson(e))
              .toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<CongViecConModel>> loadCVCByIdCV(String idCongviec) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request(
        'GET',
        Uri.parse(
          '${dotenv.env['API_URL']}/api/congviec/GetByIdCongViecCVC/$idCongviec',
        ),
      );
      request.headers.addAll(headers);

      final response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return (apiResponse.data as List)
              .map((e) => CongViecConModel.fromJson(e))
              .toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<CongViecConModel>> updateCVC(CongViecConModel cvc) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request(
        'PUT',
        Uri.parse(
          '${dotenv.env['API_URL']}/api/congviec/UpdateCVC?userName=${prefs.getString('userName')}',
        ),
      );
      request.headers.addAll(headers);
      request.body = json.encode(cvc.toJson());

      final response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        final apiResponse = ApiResponseModel.fromJson(decoded);

        if (apiResponse.success) {
          return [];
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<CongViecConModel>> insertCVC(CongViecConModel cvc) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception('Token không tồn tại!');
    }

    final url = Uri.parse(
      '${dotenv.env['API_URL']}/api/congviec/InsertCVC?userName=${cvc.createBy}',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request =
          http.Request('POST', url)
            ..headers.addAll(headers)
            ..body = json.encode(cvc.toJson());

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500 || response.statusCode == 404) {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        final data = apiResponse.data as List<dynamic>?;

        return data != null
            ? data.map((e) => CongViecConModel.fromJson(e)).toList()
            : [];
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }

  Future<List<CongViecConModel>> deleteCVC(String id, String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception('Token không tồn tại!');
    }

    final url = Uri.parse(
      '${dotenv.env['API_URL']}/api/congviec/DeleteByIdCVC/$id?userName=$userName',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request('DELETE', url)..headers.addAll(headers);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500 || response.statusCode == 404) {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        final data = apiResponse.data as List<dynamic>?;

        return data != null
            ? data.map((e) => CongViecConModel.fromJson(e)).toList()
            : [];
      } else {
        throw Exception(apiResponse.message);
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

  List<CongViecModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => CongViecModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
