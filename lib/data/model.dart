class CovidStats {
  final GlobalStats globalStats;
  final CountryList countryList;

  CovidStats({this.globalStats, this.countryList});
}

class GlobalStats {
  final int cases;
  final int mild;
  final int deaths;
  final int critical;
  final int recovered;
  final int todayDeaths;
  final int todayCases;
  final double casesPerMillion;
  final double deathsPerMillion;
  final int tests;
  final double testsPerMillion;
  final int affectedCountries;
  final DateTime updated;

  GlobalStats({
    this.cases,
    this.deaths,
    this.critical,
    this.recovered,
    this.todayDeaths,
    this.todayCases,
    this.casesPerMillion,
    this.deathsPerMillion,
    this.tests,
    this.testsPerMillion,
    this.affectedCountries,
    updated,
  })  : this.mild = cases - deaths - recovered - critical,
        this.updated = DateTime.fromMillisecondsSinceEpoch(updated);

  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    return GlobalStats(
      cases: json['cases'],
      deaths: json['deaths'],
      critical: json['critical'],
      recovered: json['recovered'],
      todayDeaths: json['todayDeaths'],
      todayCases: json['todayCases'],
      casesPerMillion: json['casesPerOneMillion'].toDouble(),
      deathsPerMillion: json['deathsPerOneMillion'].toDouble(),
      tests: json['tests'],
      testsPerMillion: json['testsPerOneMillion'].toDouble(),
      affectedCountries: json['affectedCountries'],
      updated: json['updated'],
    );
  }
}

class CountryList {
  final List<CountryStats> list;

  CountryList({this.list});

  factory CountryList.fromJson(List<dynamic> json) {
    List<CountryStats> list = List();
    for (Map<String, dynamic> item in json) {
      list.add(CountryStats.fromJson(item));
    }
    return CountryList(list: list);
  }
}

class CountryStats {
  final String country;
  final int cases;
  final int deaths;
  final int todayCases;
  final int todayDeaths;
  final int recovered;
  final int active;
  final String iso2;

  CountryStats({
    country,
    this.cases = 0,
    this.deaths = 0,
    this.todayCases = 0,
    this.todayDeaths = 0,
    this.recovered = 0,
    this.iso2 = 'XX',
  })  : this.country = country.split(',')[0],
        this.active = cases - deaths - recovered;

  factory CountryStats.fromJson(Map<String, dynamic> json) {
    return CountryStats(
      country: json['country'],
      cases: json['cases'],
      deaths: json['deaths'],
      todayCases: json['todayCases'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      iso2: json['countryInfo']['iso2'],
    );
  }
}

class Stats {
  final DateTime lastFetch;
  final CountryStats countryStats;
  final GlobalStats globalStats;

  Stats({this.globalStats, this.countryStats})
      : this.lastFetch = DateTime.now();
}

const WORLDOMETERS_URL = "https://www.worldometers.info/coronavirus/";
