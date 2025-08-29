import 'dart:convert';
import 'logger.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiMethods {
  Future<Map<String, dynamic>> postData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": "test value",
        "body": "test body",
        "userId": 1000,
      }),
    );

    // just to app can understand we send JSON
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw 'Unknown Error!';
    }
  }

  Future<List<dynamic>> getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'User-Agent': 'FlutterApp/1.0'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      logger.e(response.statusCode);

      throw 'Error!';
    }
  }

  Future<Map<String, dynamic>> fullUpdateData(int id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final body = {
      'title': 'testTitle new!!!',
      'body': 'testBody new!!!',
      'userId': 3,
    };
    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        logger.e(response.statusCode);
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> partUpdateData(int id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final partial = {'title': 'change title!!!'};
    try {
      final response = await http
          .patch(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(partial),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        logger.e(response.statusCode);
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteData(int id) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');

    try {
      final response = await http
          .delete(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        logger.e(response.statusCode);
        throw Exception('delete failded');
      }
    } catch (e) {
      rethrow;
    }
  }
}
