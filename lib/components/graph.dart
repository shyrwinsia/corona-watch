import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/extras/chart/pie_chart.dart';
import 'package:covidwatch/extras/chart/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class GlobalGraph extends StatelessWidget {
  final GlobalStats stats;

  GlobalGraph(this.stats);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _StatChart(stats),
          SizedBox(height: 8),
          Divider(
            color: Colors.white.withOpacity(0.4),
          ),
          SizedBox(height: 8),
          _StatCard(title: 'New Cases', value: stats.todayCases),
          _StatCard(title: 'New Deaths', value: stats.todayDeaths),
          _StatCard(title: 'Cases per million', value: stats.casesPerMillion),
          _StatCard(title: 'Deaths per million', value: stats.deathsPerMillion),
          _StatCard(title: 'Tests per million', value: stats.testsPerMillion),
          _StatCard(title: 'Tests Conducted', value: stats.tests),
          _StatCard(
              title: 'Affected Countries', value: stats.affectedCountries),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Last update ${timeago.format((stats.updated))}',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 10),
              ),
              FlatButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  'Visit worldometers.info',
                  style: TextStyle(
                      color: Color(0xff8fa7f4).withOpacity(0.8), fontSize: 10),
                ),
                onPressed: () async {
                  if (await canLaunch(WORLDOMETERS_URL)) {
                    await launch(WORLDOMETERS_URL);
                  } else {
                    throw 'Could not launch $WORLDOMETERS_URL';
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChart extends StatelessWidget {
  final Map<String, double> dataMap = Map();
  final GlobalStats stats;

  _StatChart(this.stats) {
    dataMap.putIfAbsent("mild", () => stats.mild.toDouble());
    dataMap.putIfAbsent("critical", () => stats.critical.toDouble());
    dataMap.putIfAbsent("ok", () => stats.recovered.toDouble());
    dataMap.putIfAbsent("dead", () => stats.deaths.toDouble());
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CustomGraph(dataMap, stats.cases, stats.todayCases),
        _StatTile(defaultColorList[0], 'Mild / Moderate', stats.mild),
        _StatTile(defaultColorList[1], 'Severe / Critical', stats.critical),
        _StatTile(defaultColorList[2], 'Recovered', stats.recovered),
        _StatTile(defaultColorList[3], 'Dead', stats.deaths),
      ],
    );
  }
}

class _CustomGraph extends StatelessWidget {
  final Map<String, double> dataMap;
  final int cases;
  final int plus;

  _CustomGraph(
    this.dataMap,
    this.cases,
    this.plus,
  );

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    double chartRadiusFactor =
        MediaQuery.of(context).size.aspectRatio > 0.6 ? 0.5 : 0.625;
    double fontSize = MediaQuery.of(context).size.aspectRatio > 0.6 ? 10 : 12;
    TextStyle chartTitleStyle = MediaQuery.of(context).size.aspectRatio > 0.6
        ? TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )
        : TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          );

    TextStyle chartTextStyle = MediaQuery.of(context).size.aspectRatio > 0.6
        ? TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          )
        : TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          );

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
      child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width * chartRadiusFactor,
          showChartValuesInPercentage: true,
          showChartValues: false,
          showChartValuesOutside: true,
          showLegends: false,
          decimalPlaces: 1,
          showChartValueLabel: true,
          initialAngle: 1.1,
          chartType: ChartType.ring,
          chartValueStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: fontSize,
          ),
          chartTitle: this.cases.toString().replaceAllMapped(reg, mathFunc),
          chartTitleStyle: chartTitleStyle,
          chartText: "Cases Worldwide",
          chartTextStyle: chartTextStyle),
    );
  }
}

class _StatTile extends StatelessWidget {
  final Color color;
  final String label;
  final num value;

  _StatTile(this.color, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(FeatherIcons.circle, color: color, size: 10),
              SizedBox(
                width: 6,
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
          Text(
            value.toString().replaceAllMapped(reg, mathFunc),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final num value;

  _StatCard({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            this.title,
            style:
                TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
          ),
          Text(
            value.toString().replaceAllMapped(reg, mathFunc),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CountryGraph extends StatelessWidget {
  final Map<String, double> dataMap = Map();
  final CountryStats stats;

  CountryGraph(this.stats);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _StatTile(
          Color(0xffffffff),
          'Total Cases',
          stats.cases,
        ),
        _StatTile(
          Color(0xfff5c76a),
          'Active',
          stats.active,
        ),
        _StatTile(
          Color(0xffff653b),
          'Deaths',
          stats.deaths,
        ),
        _StatTile(
          Color(0xff9ff794),
          'Recovered',
          stats.recovered,
        )
      ],
    );
  }
}
