import 'dart:convert';

import 'package:http/http.dart' as http;

class MailHelper {
  Future sendMail({
    required String verificationCode,
    required String userMail,
  }) async {
    final url = Uri.parse('https://api.mailjet.com/v3.1/send');
    final basicAuth = 'Basic ' +
        base64.encode(
          utf8.encode(
            'efea767c487dab2e925eff596750b895:91be0a3ccf8dc813e6793aedeefe6741',
          ),
        );
    final http.Response response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'Messages': [
            {
              'To': [
                {
                  'Email': userMail,
                }
              ],
              'TemplateID': 4983811,
              'TemplateLanguage': true,
              'variables': {
                'verification_code': verificationCode,
              }
            }
          ]
        },
      ),
    );
  }
}
