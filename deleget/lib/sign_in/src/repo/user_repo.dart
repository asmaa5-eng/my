// lib/src/repo/user_repo.dart  (عدّلي المسار حسب مشروعك)
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:lol/model/user.dart';

class UserRepo {
  Future<http.Response> registerUser(User user) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/company-users/login');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: convert.jsonEncode({
        // 'name': user.name,
        'email': user.email,
        'password': user.password,
        // 'company_id': user.companyId,
        // 'organization_level_id': user.organizationLevelId,
        // 'manager_id': user.managerId,
        // 'latitude': user.latitude,
        // 'longitude': user.longitude,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) return res;
    throw Exception('Failed: ${res.statusCode} ${res.body}');
  }
}
