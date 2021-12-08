import 'dart:convert';
import 'dart:io';
import 'package:budget_tracker/fail_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:budget_tracker/item_model.dart';

class BudgetApi {
  static const String _baseUrl = 'https://api.notion.com/v1/';

  final http.Client _client;

  BudgetApi({http.Client? client}) : _client = client ?? http.Client();

  void dispose() => _client.close();

  Future<List<Item>> getItems() async {
    try {
      final url =
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['NOTION_API_KEY']}',
          "Access-Control-Allow-Origin": "*",
          'Notion-Version': '2021-08-16',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw const Fail(message: 'Something went wrong!');
      }
    } catch (e) {
      throw const Fail(message: 'Something went wrong!');
    }
  }
}
