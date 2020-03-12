import 'dart:convert';

import 'package:covidwatch/model.dart';
import 'package:http/http.dart' as http;

class RestApi {
  static const URL_ALL = 'https://corona.lmao.ninja/all';
  static const URL_COUNTRIES = 'https://corona.lmao.ninja/countries';
  // static const URL_ALL = 'http://192.168.1.123:3000/all';
  // static const URL_COUNTRIES = 'http://192.168.1.123:3000/countries';

  static Future<GlobalStats> fetchGlobal() async {
    final response = await http.get(URL_ALL);

    print('$URL_ALL: ${response.statusCode}');
    if (response.statusCode == 200) {
      return GlobalStats.fromJson(json.decode(response.body));
    } else {
      if (response.statusCode == 429)
        print('Retry after ${response.headers['retry-after']}s');
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  static Future<CountryStats> fetchCountries() async {
    final response = await http.get(URL_COUNTRIES);
    print(response.body);
    print('$URL_COUNTRIES: ${response.statusCode}');
    return CountryStats();
  }
}
