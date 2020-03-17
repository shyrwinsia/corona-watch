import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:covidwatch/data/model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestApi {
  static const HOST = 'corona.lmao.ninja';
  static const URL_GLOBAL = 'http://$HOST/all';
  static const URL_COUNTRIES = 'http://$HOST/countries';
  static const TIMEOUT = 10;
  static const SLEEP = 1000;
  static const TIME_UNTIL_NEXT_FETCH = 30000;
  static const FAKE_FETCH_TIME = 1985;

  static Future<CovidStats> fetch() async {
    if (await _shouldFetch()) {
      try {
        final responseGlobal =
            await http.get(URL_GLOBAL).timeout(Duration(seconds: TIMEOUT));
        _checkResponseCode(responseGlobal);

        await _sleep(SLEEP);

        final responseCountries =
            await http.get(URL_COUNTRIES).timeout(Duration(seconds: TIMEOUT));
        _checkResponseCode(responseCountries);

        final prefs = await SharedPreferences.getInstance();
        prefs.setInt(
            'lastFetchTimestamp', DateTime.now().millisecondsSinceEpoch);

        // save the jsons to file
        await _writeToFile('global', responseGlobal.body);
        await _writeToFile('countries', responseCountries.body);

        return CovidStats(
          globalStats: GlobalStats.fromJson(
            json.decode(responseGlobal.body),
          ),
          countryList: CountryList.fromJson(
            json.decode(responseCountries.body),
          ),
        );
      } on TimeoutException catch (e) {
        print(e.toString());
        throw RestApiException(
            "I couldn't reach the server. 😔\nTry again after a while.");
      }
    } else {
      // just some arbitrary number to make
      // it feel like its fetching for user experience
      await _sleep(FAKE_FETCH_TIME);

      return CovidStats(
        globalStats: GlobalStats.fromJson(
          json.decode(await _readFromFile('global')),
        ),
        countryList: CountryList.fromJson(
          json.decode(await _readFromFile('countries')),
        ),
      );
    }
  }

  static Future<void> _writeToFile(String filename, dynamic data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename.json');
    file.writeAsString(data);
  }

  static Future<String> _readFromFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename.json');
    return file.readAsString();
  }

  static Future<bool> _shouldFetch() async {
    final prefs = await SharedPreferences.getInstance();
    int lastFetchTimestamp = prefs.getInt('lastFetchTimestamp') ?? -1;
    if (lastFetchTimestamp < 0) {
      return true;
    } else if (DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(
        lastFetchTimestamp + TIME_UNTIL_NEXT_FETCH))) {
      return true;
    } else {
      return false;
    }
  }

  static void _checkResponseCode(response) {
    if (response.statusCode == 200)
      return;
    else if (response.statusCode == 429)
      throw RestApiException(
          'Request limit reached. 😵\nRetry after ${response.headers['retry-after']} seconds.');
    else
      throw RestApiException(
          'Request failed. 😲\nHTTP ${response.statusCode}: ${response.reasonPhrase}');
  }

  static Future _sleep(int millis) {
    return Future.delayed(Duration(milliseconds: millis));
  }
}

class RestApiException implements Exception {
  final String message;

  RestApiException(this.message);

  String toString() => this.message;
}
