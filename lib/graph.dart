import 'package:corona_watch/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'chart/pie_chart.dart';

class Graph extends StatelessWidget {
  final Map<String, double> dataMap = new Map();
  final GlobalStats stats;

  Graph(this.stats) {
    dataMap.putIfAbsent("active", () => stats.active.toDouble());
    dataMap.putIfAbsent("dead", () => stats.deaths.toDouble());
    dataMap.putIfAbsent("ok", () => stats.recovered.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildGraph(context),
        _statTile(Color(0xffffffff), 'Total Cases', stats.cases.toString()),
        _statTile(Color(0xfff5c76a), 'Infected', stats.active.toString()),
        _statTile(Color(0xffff653b), 'Dead', stats.deaths.toString()),
        _statTile(Color(0xff9ff794), 'Recovered', stats.recovered.toString()),
      ],
    );
  }

  Widget _buildGraph(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 1.6,
          showChartValuesInPercentage: true,
          showChartValues: false,
          showChartValuesOutside: true,
          colorList: [Color(0xfff5c76a), Color(0xffff653b), Color(0xff9ff794)],
          showLegends: false,
          decimalPlaces: 1,
          showChartValueLabel: true,
          initialAngle: 4.5,
          chartType: ChartType.ring,
          chartValueStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
          ),
          title: 'Worldwide',
        ),
      ],
    );
  }

  Widget _statTile(Color color, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
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
                    fontSize: 14, color: Colors.white.withOpacity(0.6)),
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
}
