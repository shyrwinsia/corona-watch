import 'dart:async';

import 'package:covidwatch/api.dart';
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
          IconButton(
              icon: Icon(FeatherIcons.refreshCw),
              iconSize: 16,
              onPressed: () => _fetch())
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
                    SizedBox(height: 16),
                    Text(
                      'Fetching latest updates',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
        Graph(stats),
        FlatButton(
          child: Text('View countries',
              style: TextStyle(color: Color(0xff8fa7f4))),
          onPressed: () {},
        ),
      ],
    );
  }

  void _fetch() async {
    stats.add(null);
    await RestApi.fetchGlobal().catchError((onError) {
      print('Some error occured');
      stats.addError(onError);
    }).then((globalStats) => stats.add(globalStats));
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
// [ ] black splash screen
// [ ] error for no connection
// [x] prevent landscape
// [x] make private function
// [ ] add countries
