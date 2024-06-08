
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notesappflutter/models/response_model.dart';
import 'package:notesappflutter/services/storage_services.dart';
import 'package:notesappflutter/utils/configs/api_config.dart';


class AuthServices {
  static String baseUrl = ApiConfig.baseUrl;

  Future<ResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
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
        await StorageServices.setAccessToken(
          accessToken: responseJson["data"]["accessToken"],
        );
      }
      return ResponseModel.fromJson(responseJson);
    } catch(err) {
      return ResponseModel(
        status: "failed", 
        message: "can't connect to server"
      );
    }
  }
}