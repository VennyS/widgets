import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:widgets/models/list_item.dart';

class Api {
  static final Api _instance = Api._internal();
  late String baseUrl;

  factory Api() {
    return _instance;
  }

  Api._internal();

  Future<void> setBaseUrl(String url) async {
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

    // Возвращаем и тело ответа, и код статуса
    return {
      'statusCode': response.statusCode,
      'body': response.statusCode == 200 || response.statusCode == 201
          ? json.decode(response.body)
          : null
    };
  }

  Future<String> singUpOrCancelRecord(String name, String phone, int gtoID,
      String status, String? userID) async {
    final url = '$baseUrl/test/user_records/';

    // Данные, которые отправляем в POST-запросе
    final data = {
      'name': name,
      'phone': phone,
      'gto_id': gtoID.toString(),
      'status': status,
      'user_id': userID,
    };

    // Отправляем POST-запрос с данными
    final response = await _postRequest(url, data);

    return response['body'];
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
