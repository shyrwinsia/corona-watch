import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:covidwatch/data/model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestApi {
  static const HOST = '10.0.2.2:3000';
  static const URL_GLOBAL = 'http://$HOST/all';
  static const URL_COUNTRIES = 'http://$HOST/countries';
  static const TIMEOUT = 10; // 10s http timeout
  static const SLEEP = 1000; // 1s sleep to prevent rate-limiting
  static const TIME_UNTIL_NEXT_FETCH = 60000; // 60s caching
  static const FAKE_FETCH_TIME = 1985; // 1.985s of fake loading

  static Future<AppModel> fetch() async {
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

        return AppModel(
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
          cause: "Can't reach the server",
          action: "Try again after a while",
        );
      } on SocketException catch (e) {
        print(e.toString());
        throw RestApiException(
          cause: "No connection",
          action: "Turn on your wifi or data",
        );
      }
    } else {
      // just some arbitrary number to make
      // it feel like its fetching for user experience
      await _sleep(FAKE_FETCH_TIME);

      return AppModel(
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
    int code = response.statusCode;
    if (code == 200)
      return;
    else if (code == 429) {
      String action = response.headers['retry-after'] != null
          ? "Retry after ${response.headers['retry-after']} seconds"
          : 'Retry after a few minutes';
      throw RestApiException(
        cause: 'Request limit reached',
        action: action,
      );
    } else if (code >= 500 && code < 600) {
      // cloudfare errors usually happen
      throw RestApiException(
        cause: 'Error ${response.statusCode}: ${response.reasonPhrase}',
        action: 'Please hit refresh after a few seconds',
      );
    } else {
      throw RestApiException(
        cause: 'Error ${response.statusCode}: ${response.reasonPhrase}',
        action: 'Please send a screenshot to developer',
      );
    }
  }

  static Future _sleep(int millis) {
    return Future.delayed(Duration(milliseconds: millis));
  }
}

class RestApiException implements Exception {
  final String cause;
  final String action;

  RestApiException({this.cause, this.action});

  String toString() => "${this.cause} ${this.action}";
}
