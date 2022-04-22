import 'package:GIFTR/data/gift.dart';
import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/person.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  final String _domain = '192.168.2.67:3030';
  final String _signupPath = 'auth/users';
  final String _logUserPath = 'auth/tokens';
  final String _validateTokenPath = 'auth/users/me';
  final String _peoplePath = 'api/people';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'x-api-key': 'legu0027',
  };

  Future<bool> createUser(Map<String, dynamic> user) async {
    user['firstName'] = 'Fernando';
    user['lastName'] = 'Leguia';
    Uri uri = Uri.http(_domain, _signupPath);
    http.Response response =
        await http.post(uri, headers: _headers, body: jsonEncode(user));

    Map<String, dynamic> data = jsonDecode(response.body);

    print("response from signup: $data with user: $user");

    if (data.containsKey('data')) {
      return loginUser(user);
    }

    return false;
  }

  Future<bool> loginUser(Map<String, dynamic> user) async {
    Uri uri = Uri.http(_domain, _logUserPath);
    http.Response response =
        await http.post(uri, headers: _headers, body: jsonEncode(user));

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 401 && data['errors'] != null) {
      throw GiftrException.INCORRECT_USERNAME_PASSWORD;
    }

    if (data.containsKey('data')) {
      String JWTtoken = data['data']['token'];
      var pref = await SharedPreferences.getInstance();
      pref.setString('token', JWTtoken);
      return true;
    }

    return false;
  }

  Future<List<Person>> grabPeopleList() async {
    Uri uri = Uri.http(_domain, _peoplePath);
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.get(uri, headers: _headers);
    Map<String, dynamic> data = jsonDecode(response.body);

    return Person.toList(data['data']);
  }

  Future<List<Gift>> grabGifts(String personId) async {
    Uri uri = Uri.http(_domain, "$_peoplePath/${personId}");
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.get(uri, headers: _headers);
    Map<String, dynamic> data = jsonDecode(response.body);
    return Gift.toList(data['data']['gifts']);
  }

  Future<Gift> deleteGift(String personId, Gift gift) async {
    Uri uri = Uri.http(_domain, "$_peoplePath/$personId/gifts/${gift.id}");
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.delete(uri, headers: _headers);

    Map<String, dynamic> data = jsonDecode(response.body);
    Gift deleted = Gift.fromJson(data['data']);

    return deleted;
  }

  Future<Gift> saveGift(String personId, Gift gift) async {
    Uri uri = Uri.http(_domain, "$_peoplePath/$personId/gifts");
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.post(uri,
        headers: _headers, body: jsonEncode(gift.toJson()));

    Map<String, dynamic> data = jsonDecode(response.body);

    print("data from saving gift ${data}");
    Gift withId = Gift.fromJson(data['data']);

    return withId;
  }

  Future<Person> savePerson(Person person) async {
    Uri uri = Uri.http(_domain, _peoplePath);
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.post(uri,
        headers: _headers, body: jsonEncode(person.toJson()));

    Map<String, dynamic> data = jsonDecode(response.body);

    print("data from saving person ${data}");
    Person withId = Person.fromJson(data['data']);
    return withId;
  }

  Future<Person> updatePerson(Person person) async {
    Uri uri = Uri.http(_domain, "$_peoplePath/${person.id}");
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.patch(uri,
        headers: _headers, body: jsonEncode(person.toJson()));

    Map<String, dynamic> data = jsonDecode(response.body);
    Person patched = Person.fromJson(data['data']);
    return patched;
  }

  Future<Person> deletePerson(Person person) async {
    Uri uri = Uri.http(_domain, "$_peoplePath/${person.id}");
    _headers['Authorization'] = 'Bearer ${await getToken()}';
    http.Response response = await http.delete(uri, headers: _headers);

    Map<String, dynamic> data = jsonDecode(response.body);
    Person deleted = Person.fromJson(data['data']);
    return deleted;
  }

  Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("token from shared preferences: $token");
    if (token == null || token.isEmpty) {
      throw GiftrException.INVALID_TOKEN;
    }

    //Validates the token making a request to /users/me path
    Uri uri = Uri.http(_domain, _validateTokenPath);
    _headers['Authorization'] = 'Bearer ${token}';
    http.Response response = await http.get(uri, headers: _headers);
    // try {} catch (e) {}
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 400 || data['errors'] != null) {
      throw GiftrException.INVALID_TOKEN;
    }

    return token;
  }
}
