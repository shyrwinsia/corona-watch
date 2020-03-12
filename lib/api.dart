import 'dart:convert';

import 'package:async/async.dart';
import 'package:corona_watch/model.dart';
import 'package:http/http.dart' as http;

class RestApi {
  static const URL_ALL = 'https://corona.lmao.ninja/all';
  static const URL_COUNTRIES = 'https://corona.lmao.ninja/countries';

  static Future<Stats> fetch() async {
    FutureGroup fetch = FutureGroup();
    fetch.add(_fetchGlobal());
    fetch.add(_fetchCountries());
    fetch.close();

    List stats = await fetch.future;

    return Stats(
      globalStats: stats.elementAt(0),
      countryStats: CountryStats(),
    );
  }

  static Future<GlobalStats> _fetchGlobal() async {
    final response = await http.get(URL_ALL);

    if (response.statusCode == 200) {
      return GlobalStats.fromJson(json.decode(response.body));
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  static Future<CountryStats> _fetchCountries() async {
    final response = await http.get(URL_COUNTRIES);
    print(response.body);
    return CountryStats();
  }
}
