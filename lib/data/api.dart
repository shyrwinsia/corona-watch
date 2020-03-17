import 'dart:async';
import 'dart:convert';

import 'package:covidwatch/data/model.dart';
import 'package:http/http.dart' as http;

class RestApi {
  static const HOST = 'corona.lmao.ninja';
  // static const HOST = '192.168.1.123:3000';
  static const URL_ALL = 'http://$HOST/all';
  static const URL_COUNTRIES = 'http://$HOST/countries';
  static const TIMEOUT = 10;
  static const SLEEP = 1000;

  static Future<CovidStats> fetch() async {
    final globalStats = await _fetchGlobal();
    _sleep();
    final countryList = await _fetchCountries();
    return CovidStats(globalStats: globalStats, countryList: countryList);
  }

  static Future<GlobalStats> _fetchGlobal() async {
    try {
      final response =
          await http.get(URL_ALL).timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        return GlobalStats.fromJson(json.decode(response.body));
      } else {
        if (response.statusCode == 429)
          throw RestApiException(
              'Request limit reached. 😵\nRetry after ${response.headers['retry-after']} seconds.');
        else
          throw RestApiException(
              'Request failed. 😲\nHTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException catch (e) {
      print(e.toString());
      throw RestApiException(
          "I couldn't reach the server. 😔\nTry again after a while.");
    }
  }

  static Future<CountryList> _fetchCountries() async {
    final response =
        await http.get(URL_COUNTRIES).timeout(Duration(seconds: TIMEOUT));
    if (response.statusCode == 200) {
      return CountryList.fromJson(json.decode(response.body));
    } else {
      if (response.statusCode == 429)
        print('Retry after ${response.headers['retry-after']}s');
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  static Future _sleep() {
    return Future.delayed(Duration(milliseconds: SLEEP));
  }
}

class RestApiException implements Exception {
  final String message;

  RestApiException(this.message);

  String toString() => this.message;
}
