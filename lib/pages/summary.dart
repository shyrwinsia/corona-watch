import 'package:covidwatch/bloc/homepage/bloc.dart';
import 'package:covidwatch/components/graph.dart';
import 'package:covidwatch/data/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final GlobalStats globalStats;
  final HomePageBloc bloc;

  SummaryPage(this.globalStats, this.bloc);

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
        actions: <Widget>[
          IconButton(
              icon: Icon(FeatherIcons.refreshCw),
              iconSize: 16,
              onPressed: () => bloc.add(LoadGlobalStats())),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GlobalGraph(globalStats),
      ),
    );
  }
}
