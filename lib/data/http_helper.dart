import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HttpHelper {
  final String _domain = '192.168.2.67:3030';
  final String _logUserPath = 'auth/tokens';
  final String _peoplePath = 'api/people';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'x-api-key': 'legu0027',
  };

  Future<Map<String, dynamic>> loginUser(Map<String, dynamic> user) async {
    Uri uri = Uri.http(_domain, _logUserPath);
    http.Response response =
        await http.post(uri, headers: _headers, body: jsonEncode(user));

    Map<String, dynamic> data = jsonDecode(response.body);
    print('result from network: $data');
    if (data.containsValue("errors")) {
      throw Exception(data["errors"][0]["title"]);
    }
    return data;
  }

  Future<Map<String, dynamic>> grabPeopleList(String token) async {
    Uri uri = Uri.http(_domain, _peoplePath);
    _headers['Authorization'] = 'Bearer $token';
    http.Response response = await http.get(uri, headers: _headers);
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }
}
