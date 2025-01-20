import 'dart:convert';
import 'package:http/http.dart' as http;

class PreludeHelper {
  final String apiKey = 'sk_pbeoXvP7Il8MNg069UcaOjmSdkBVAQTU'; // Secret. v2
  // final String apiKey = 'sk_Sd02JrLSatdcSnn2B8SblI7lqA9h4sdh'; // Secret. v2 Test
  // final String apiKey = 'OKQbROYNnY2w0FdtoVo2c6Ti9BjeS6Wm4K4JCYfH'; // Secret. v1
  // final String UUID = '3772e12c-38bc-4b20-8566-d227845d7697'; // Secret. v1
  final String baseUrl = 'https://api.prelude.dev/v2';

  Future sendOTP({
    required String verificationCode,
    required String userMail, // Remove
    required String userPhoneNumber,
  }) async {
    final url = Uri.parse('$baseUrl/verification');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'target': {
            'type': 'phone_number',
            'value': userPhoneNumber,
          },
          // 'code': verificationCode,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 400) {
        print('Bad Request: Check the phone number format.');
      } else if (response.statusCode == 401) {
        print('Unauthorized: Check your API key.');
      } else if (response.statusCode == 429) {
        print('Too Many Requests: Rate limit exceeded.');
      } else {
        print('Unexpected error: ${response.body}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }
}
