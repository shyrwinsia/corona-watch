import 'package:covidwatch/components/graph.dart';
import 'package:covidwatch/data/model.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final GlobalStats globalStats;

  SummaryPage(this.globalStats);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "SUMMARY",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GlobalGraph(globalStats),
      ),
    );
  }
}
