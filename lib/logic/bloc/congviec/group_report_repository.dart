import 'dart:convert';
import 'package:ducanherp/data/models/group_report_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroupReportRepository {
  final http.Client client;
  final SharedPreferences prefs;
  GroupReportRepository({required this.client, required this.prefs});

  Future<List<GroupReportModel>> fetchGroupReport({
    required String groupId,
    required String idNguoiGiaoViec,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/congviec/BaoCaoTheoNhom?groupId=$groupId&id_NguoiGiaoViec=$idNguoiGiaoViec',
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
        final List<dynamic> data = decoded['data'] ?? [];
        return data.map((e) => GroupReportModel.fromJson(e)).toList();
      } else {
        throw Exception(decoded['message'] ?? 'Lỗi không xác định');
      }
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
