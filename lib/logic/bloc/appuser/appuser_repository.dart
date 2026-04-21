import 'package:ducanherp/data/repositories/api_response_model.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/changepassword_mode.dart';
import 'package:ducanherp/data/models/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUserRepository {
  final http.Client client;
  final SharedPreferences prefs;

  AppUserRepository({required this.client, required this.prefs});

  Future<ApiResponseModel> login(String email, String password) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/api/user/Login'),
    );
    request.body = json.encode({
      "Email": email,
      "Password": password,
      "RememberMe": true,
    });
    request.headers.addAll(headers);

    final response = await request.send().timeout(const Duration(seconds: 15));
    final responseString = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseString);

    return ApiResponseModel.fromJson(jsonResponse);
  } catch (e) {
    return ApiResponseModel(
      success: false,
      message: 'Đăng nhập thất bại: $e',
      data: null,
    );
  }
}

  Future<ApplicationUser?> fetchUserInfo(String email) async {
    final userInfoRequest = http.Request(
      'GET',
      Uri.parse(
        '${dotenv.env['API_URL']}/api/ApplicationUser/getInforUser?userName=$email',
      ),
    );
     final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    userInfoRequest.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    final userInfoResponse = await userInfoRequest.send();
    final response = await http.Response.fromStream(userInfoResponse);

    if (userInfoResponse.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);
      if (apiResponse.success) {
        return ApplicationUser.fromJson(apiResponse.data);
      }
    }
    return null;
  }

  Future<void> saveToken(String token, String expiration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('expiration', expiration);
  }

  Future<void> saveUserInfo(ApplicationUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', json.encode(user.toJson()));
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('expiration');
    await prefs.remove('userInfo');
  }

  Future<Map<String, dynamic>> register(RegisterModel model) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/api/user/register'),
    );
    request.body = json.encode(model.toJson());
    request.headers.addAll(headers);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    return {
      'statusCode': response.statusCode,
      'body': responseString,
      'reasonPhrase': response.reasonPhrase,
    };
  }

  Future<Map<String, dynamic>> changePassword({
    required ChangePasswordModel changePasswordModel,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    // Lấy email từ userInfo
    final userInfoString = prefs.getString('userInfo');
    if (userInfoString == null) throw Exception('User info không tồn tại');
    final userInfo = json.decode(userInfoString);
    final email = userInfo['email'] ?? '';

    // Gán lại email vào model
    final updatedModel = ChangePasswordModel(
      email: email,
      currentPassword: changePasswordModel.currentPassword,
      newPassword: changePasswordModel.newPassword,
      confirmPassword: changePasswordModel.confirmPassword,
    );

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.Request(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/api/user/ChangePassword'),
    );

    request.body = json.encode(updatedModel.toJson());
    request.headers.addAll(headers);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    return {
      'statusCode': response.statusCode,
      'body': responseString,
      'reasonPhrase': response.reasonPhrase,
    };
  }

  Future<Map<String, dynamic>>  deleteCurrentUser() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    // Lấy email từ userInfo
    final userInfoString = prefs.getString('userInfo');
    if (userInfoString == null) throw Exception('User info không tồn tại');
    final userInfo = json.decode(userInfoString);
    final email = userInfo['email'] ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${dotenv.env['API_URL']}/api/user/DeleteCurrentUser?email=$email');
    final request = http.Request('DELETE', url)..headers.addAll(headers);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    return {
      'statusCode': response.statusCode,
      'body': responseString,
      'reasonPhrase': response.reasonPhrase,
    };
  }
  Future<Map<String, dynamic>>  qrLogin(String sessionId) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    // Lấy email từ userInfo
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${dotenv.env['API_URL']}/api/user/qr-login?sessionId=$sessionId');
    final request = http.Request('POST', url)..headers.addAll(headers);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    return {
      'statusCode': response.statusCode,
      'body': responseString,
      'reasonPhrase': response.reasonPhrase,
    };
  }
}
