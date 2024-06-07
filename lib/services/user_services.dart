import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notesappflutter/models/response_model.dart';
import 'package:notesappflutter/utils/configs/api_config.dart';


class UserServices {
  final String baseUrl = ApiConfig.baseUrl;

  Future<ResponseModel> registerUser({
    required String fullName,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({
          "fullname": fullName,
          "username": username,
          "password": password,
        }),
      );
      
      final responseJson = jsonDecode(response.body);
      return ResponseModel.fromJson(responseJson);
    } catch(err) {
      return ResponseModel(
        status: "failed",
        message: "tidak dapat terhubung ke server"
      );
    }
  }
}