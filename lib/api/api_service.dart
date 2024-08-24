import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:widgets/models/list_item.dart';
import 'package:logger/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late String baseUrl;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  void setBaseUrl(String url) {
    baseUrl = url;
  }

  Future<Map<String, dynamic>> _postRequest(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type':
            'application/json', // Указываем, что данные будут в формате JSON
      },
      body: json.encode(data), // Преобразуем карту данных в JSON-строку
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'statusCode': response.statusCode,
        'body':
            utf8.decode(response.bodyBytes), // Декодируем bodyBytes как UTF-8
      };
    } else {
      return {
        'statusCode': response.statusCode,
        'body': 'Error: ${response.statusCode}'
      };
    }
  }

  Future<String?> signUp(
      String name, String phone, int gtoID, String status) async {
    final url = '$baseUrl/test/user_records/';
    final data = {
      'name': name,
      'phone': phone,
      'group_training_object_id': gtoID,
      'status': "Tururu777",
    };

    final response = await _postRequest(url, data);
    final body = response['body'];

    Logger().i("url: $url");
    Logger().i("данные с запросом: $data");

    // Если body - это строка и не содержит ошибки, вернем её
    if (body is String && !body.contains("Error")) {
      Logger().i("ответ: $response");
      return body; // Уже декодировано в _postRequest
    } else {
      Logger().e("ответ: $response");
      return null;
    }
  }

  Future<List<ListItem>> fetchListItems(int weekNumber) async {
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
