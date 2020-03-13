import 'dart:async';

import 'package:covidwatch/api.dart';
import 'package:covidwatch/countries.dart';
import 'package:covidwatch/graph.dart';
import 'package:covidwatch/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<GlobalStats> stats = StreamController();
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _fetch();
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
          _isLoading
              ? Container()
              : IconButton(
                  icon: Icon(FeatherIcons.refreshCw),
                  iconSize: 16,
                  onPressed: () => _fetch()),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder<GlobalStats>(
          stream: stats.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildGlobalStats(snapshot.data);
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Fetching latest updates',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Source: worldometers.info',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(.6)),
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

  Widget buildGlobalStats(GlobalStats stats) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GlobalGraph(stats),
        FlatButton(
            child: Text('View countries',
                style: TextStyle(color: Color(0xff8fa7f4))),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CountriesPage()))),
      ],
    );
  }

  void _fetch() async {
    stats.add(null);
    setState(() {
      _isLoading = true;
    });
    await RestApi.fetchGlobal()
        .catchError(
          (onError) {
            print('Some error occured');
            stats.addError(onError);
          },
        )
        .then((globalStats) => stats.add(globalStats))
        .then(
          (onValue) => setState(() {
            _isLoading = false;
          }),
        );
  }

  @override
  void dispose() {
    stats.close();
    super.dispose();
  }
}

// TODO
// [x] change circular progress color
// [x] change refresh to button
// [x] make the manual refresh work
// [x] black splash screen
// [ ] error for no connection
// [x] prevent landscape
// [x] make private function
// [x] add countries
// [ ] implement sort: total cases, alphabetical, new cases today, new deaths today
