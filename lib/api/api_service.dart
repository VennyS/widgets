import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:widgets/models/list_item.dart';
import 'package:logger/logger.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  ApiService._internal();

  static final ApiService _instance = ApiService._internal();

  static ApiService get instance => _instance;

  late String baseUrl;

  Future<Map<String, dynamic>> _postRequest(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'statusCode': response.statusCode,
        'body': utf8.decode(response.bodyBytes),
      };
    } else {
      return {
        'statusCode': response.statusCode,
        'body': 'Error: ${response.statusCode}'
      };
    }
  }

  static void setBaseUrl(String url) => instance._setBaseUrl(url);

  void _setBaseUrl(String url) {
    baseUrl = url;
  }

  static Future<String?> signUp(
      String name, String phone, int gtoID, String status) {
    return instance._signUp(name, phone, gtoID, status);
  }

  Future<String?> _signUp(
      String name, String phone, int gtoID, String status) async {
    final url = '$baseUrl/test/user_records/';
    final data = {
      'name': name,
      'phone': phone,
      'group_training_object_id': gtoID,
      'status': status,
    };

    final response = await _postRequest(url, data);
    final body = response['body'];

    Logger().i("url: $url");
    Logger().i("данные с запросом: $data");

    if (body is String && !body.contains("Error")) {
      Logger().i("ответ: $response");
      return body;
    } else {
      Logger().e("ответ: $response");
      return null;
    }
  }

  static Future<List<ListItem>> fetchListItems(int weekNumber) {
    return instance._fetchListItems(weekNumber);
  }

  Future<List<ListItem>> _fetchListItems(int weekNumber) async {
    final response = await http
        .get(Uri.parse('$baseUrl/test/group_training_object/$weekNumber'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      List<ListItem> items = [];

      data.forEach((timeKey, activitiesList) {
        if (activitiesList is List) {
          for (var activity in activitiesList) {
            items.add(ListItem.fromJson(activity));
          }
        }
      });

      return items;
    } else {
      throw Exception('Failed to load list items');
    }
  }
}
