
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notesapp_flutter/configs/api_config.dart';
import 'package:notesapp_flutter/models/response_model.dart';
import 'package:notesapp_flutter/services/storage/shared_storage.dart';


class AuthService {
  static String baseUrl = ApiConfig.baseUrl; // "https://canihave.my.id:443"

  Future<ResponseModel> login({ required String username, required String password }) async {
    final String url = '$baseUrl/authentications';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      })
    );

    final Map<String, dynamic> responseJson = jsonDecode(response.body); 
    if(response.statusCode == 201) {
      await SharedStorageService.setAccessToken(
        responseJson["data"]["accessToken"]
      );
    }
    return ResponseModel.fromJson(responseJson);
  }
}