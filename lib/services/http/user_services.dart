import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notesapp_flutter/configs/api_config.dart';
import 'package:notesapp_flutter/models/response_model.dart';
import 'package:notesapp_flutter/services/storage/shared_storage.dart';


class UserServices {
  final String baseUrl = ApiConfig.baseUrl;

  Future<ResponseModel> registerUser({ required String fullName, required String username, required String password }) async {
    final String? accessToken = await SharedStorageService.getAccessToken();
    
    var url = '$baseUrl/users';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
      body: jsonEncode({
        "fullname": fullName,
        "username": username,
        "password": password,
      }),
    );
    return ResponseModel.fromJson(jsonDecode(response.body));
  }
}