import 'dart:convert';
import 'package:http/http.dart' as http;

class API {

  static const String baseUrl = "https://esof-api.onrender.com";

  Future<void> banUser(String uid) async {
    final uri = Uri.parse("$baseUrl/ban");

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(<String, String>{
          'uid': uid,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to ban user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to ban user: $error');
    }
  }

  Future<void> sendMessage(String fcmToken, String userName, String text) async {
    final uri = Uri.parse("$baseUrl/send");
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fcmToken": fcmToken,"userName": userName, "bodyMessage": text}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to send message: $error');
    }
  }
}