
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notesappflutter/models/response_model.dart';
import 'package:notesappflutter/services/storage_services.dart';
import 'package:notesappflutter/utils/configs/api_config.dart';

class NoteServices {
  final String _baseUrl = "${ApiConfig.baseUrl}/notes";

  Future<ResponseModel> saveNote({required String title, required String tags, required String body}) async {
    /* merubah string to list dipisahkan dengan coma dan menghapus spasi */
    List listOfTag = tags.split(",").map((tag) => tag.trim()).toList();

    final String? accessToken = await StorageServices.getAccessToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
      body: jsonEncode({
        "title": title,
        "tags": listOfTag, // tags ini harus bertipe List
        "body": body,
      }),
    );
    final responseJson = jsonDecode(response.body);
    return ResponseModel.fromJson(responseJson);
  }

  Future<ResponseModel> getNotes() async {
    /* 
     * untuk mendapatkan semua note gunakan method http.get() method
     * pada link berikut https://notesapi.caniget.my.id:443/notes
     * gunakan auth Bearer pada bagian header
     * 
     * @return ResponseModel
     */
    final String? accessToken = await StorageServices.getAccessToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
    );

    final responseJson = jsonDecode(response.body);
    return ResponseModel.fromJson(responseJson);
  }

  Future<ResponseModel> deleteNotes({required String noteId }) async {
    /* 
     * untuk menghapus salah satu note gunakan method http.delete() method
     * pada link berikut https://notesapi.caniget.my.id:443/notes/{id}
     * gunakan noteId sebagai path parameter
     * gunakan auth Bearer pada bagian header
     * 
     * @return:  ResponseModel
     */
    final String? accessToken = await StorageServices.getAccessToken();
    
    final response = await http.delete(
      Uri.parse("$_baseUrl/$noteId"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      }
    );
    
    final responseJson = jsonDecode(response.body);
    return ResponseModel.fromJson(responseJson);
  }

  Future<ResponseModel> updateNote({
    required noteId,
    required String title,
    required String tags,
    required String body
  }) async {
    List listOfTag = tags.split(",").map((tag) => tag.trim()).toList();

    final String? accessToken = await StorageServices.getAccessToken();
    final response = await http.put(
      Uri.parse("$_baseUrl/$noteId"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
      body: jsonEncode({
        "title": title,
        "tags": listOfTag, // tags ini harus bertipe List
        "body": body,
      }),
    );
    
    final responseJson = jsonDecode(response.body);
    return ResponseModel.fromJson(responseJson);
  }
}
