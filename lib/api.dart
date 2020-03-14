import 'dart:convert';

import 'package:covidwatch/model.dart';
import 'package:http/http.dart' as http;

class RestApi {
  // static const HOST = 'corona.lmao.ninja';
  static const HOST = '192.168.1.123:3000';
  static const URL_ALL = 'http://$HOST/all';
  static const URL_COUNTRIES = 'http://$HOST/countries';

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

  static Future<CountryList> fetchCountries() async {
    final response = await http.get(URL_COUNTRIES);
    if (response.statusCode == 200) {
      return CountryList.fromJson(json.decode(response.body));
    } else {
      if (response.statusCode == 429)
        print('Retry after ${response.headers['retry-after']}s');
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
