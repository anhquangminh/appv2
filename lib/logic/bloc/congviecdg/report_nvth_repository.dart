import 'dart:convert';
import 'package:ducanherp/data/models/report_nvth_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportNVTHRepository {
  final http.Client client;
  final SharedPreferences prefs;

  ReportNVTHRepository({
    required this.client,
    required this.prefs,
  });

  Future<ReportNVTHModel> fetchReportNVTH({
    required String groupId,
    required String taiKhoan,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token không tồn tại');
    }

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/congviec/DashboardNVTH'
      '?groupId=$groupId&taiKhoan=$taiKhoan',
    );

    final response = await client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        return ReportNVTHModel.fromJson(decoded['data']);
      } else {
        throw Exception(decoded['message'] ?? 'Lỗi không xác định');
      }
    }

    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
