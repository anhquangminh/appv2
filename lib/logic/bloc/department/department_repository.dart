import 'dart:convert';
import 'package:ducanherp/data/models/dapartment_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';

class DepartmentRepository {
  final http.Client client;
  final SharedPreferences prefs;

  DepartmentRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<DepartmentModel>> fetchDepartments(DepartmentModel filter) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/NhanSu/DepartmentGetAllByVM?groupId=${filter.groupId}',
    );
    try {
      final response = await client.post(
        uri,
        headers: _buildHeaders(token),
        body: json.encode(filter.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          final List data = jsonData['data'];
          return data.map((e) => DepartmentModel.fromJson(e)).toList();
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      handleNetworkException(e);
      
    }
  }
}