import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HttpHelper {
  final String _domain = '192.168.2.67:3030';
  final String peoplePath = '/api/people/';
  final String authPath = '/auth/';
  final String _logUserPath = 'auth/tokens';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'x-api-key': 'legu0027',
  };

  Future<Map> loginUser(Map<String, dynamic> user) async {
    print("loginUser");

    //user to login
    Uri uri = Uri.http(_domain, _logUserPath);
    http.Response response =
        await http.post(uri, headers: _headers, body: jsonEncode(user));

    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }
}
