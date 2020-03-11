import 'dart:convert';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<StatsGlobal> statsGlobalFuture;
  Map<String, double> dataMap = new Map();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "COVID-19 STATISTICS",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FeatherIcons.refreshCw,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () => fetch())
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<StatsGlobal>(
          future: statsGlobalFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildGlobalStats(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white24),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Fetching data',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Source: worldometers.info',
                      style: TextStyle(
                          fontSize: 10, color: Colors.white.withOpacity(.4)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildGlobalStats(StatsGlobal stats) {
    setGraphData(stats);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartRadius: MediaQuery.of(context).size.width / 1.4,
              showChartValuesInPercentage: true,
              showChartValues: false,
              showChartValuesOutside: true,
              colorList: [
                Color(0xfff5c76a),
                Color(0xffff653b),
                Color(0xff9ff794)
              ],
              showLegends: false,
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 5,
              chartType: ChartType.ring,
              chartValueStyle: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
              title: 'Worldwide',
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            statTile(
                const Color(0xffffffff), 'Total Cases', stats.cases.toString()),
            SizedBox(
              height: 8,
            ),
            statTile(
                const Color(0xfff5c76a), 'Active', stats.active.toString()),
            SizedBox(
              height: 8,
            ),
            statTile(
                const Color(0xffff653b), 'Deaths', stats.deaths.toString()),
            SizedBox(
              height: 8,
            ),
            statTile(const Color(0xff9ff794), 'Recovered',
                stats.recovered.toString()),
          ],
        ),
        FlatButton(
          child: Text('See Countries',
              style: TextStyle(color: const Color(0xff8fa7f4))),
          onPressed: () {},
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Last fetched 4 minutes ago',
              style:
                  TextStyle(fontSize: 10, color: Colors.white.withOpacity(.4)),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Source: worldometers.info',
              style:
                  TextStyle(fontSize: 10, color: Colors.white.withOpacity(.2)),
            ),
          ],
        ),
      ],
    );
  }

  void setGraphData(StatsGlobal stats) {
    dataMap.putIfAbsent("active", () => stats.active.toDouble());
    dataMap.putIfAbsent("dead", () => stats.deaths.toDouble());
    dataMap.putIfAbsent("ok", () => stats.recovered.toDouble());
  }

  Widget statTile(Color color, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(FeatherIcons.circle,
                  color: color.withOpacity(0.8), size: 10),
              SizedBox(
                width: 6,
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(.6)),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void fetch() {
    statsGlobalFuture = fetchGlobal();
    fetchGlobal();
  }

  Future<StatsGlobal> fetchGlobal() async {
    final response = await http.get('https://corona.lmao.ninja/all');

    if (response.statusCode == 200) {
      return StatsGlobal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> fetchCountries() async {
    final response = await http.get('https://corona.lmao.ninja/countries');
    print(response.body);
  }
}

class StatsGlobal {
  final int cases;
  final int active;
  final int deaths;
  final int recovered;

  StatsGlobal({
    this.cases,
    this.deaths,
    this.recovered,
  }) : this.active = cases - deaths - recovered;

  factory StatsGlobal.fromJson(Map<String, dynamic> json) {
    return StatsGlobal(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
    );
  }
}

// TODO
// [x] change circular progress color
// [x] change refresh to button
// [ ] make the manual refresh work
// [ ] error for no connection
// [ ] prevent landscape
// [ ] make private function
// [ ] add last fetch
// [ ] add fuzzy time
// [ ] add countries
