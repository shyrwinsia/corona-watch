import 'package:covidwatch/components/flag.dart';
import 'package:covidwatch/components/graph.dart';
import 'package:covidwatch/data/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class CountryDetailPage extends StatelessWidget {
  final CountryStats countryStats;

  CountryDetailPage({this.countryStats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flags.get(countryStats.iso2, height: 14),
            SizedBox(width: 8),
            Text(
              countryStats.country.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CountryGraph(countryStats),
      ),
    );
  }
}
