import 'package:covidwatch/components/sortdialog.dart';
import 'package:covidwatch/data/model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../components/sortdialog.dart';

class SortPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
  SortBy _sortBy;
  OrderBy _orderBy;

  @override
  void initState() {
    super.initState();
    _sortBy = SortBy.totalCases;
    _orderBy = OrderBy.highestFirst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "SORT",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: _buildPreferences(context),
      ),
    );
  }

  List<Widget> _buildPreferences(BuildContext context) {
    return ListTile.divideTiles(
      context: context,
      tiles: [
        ListTile(
          title: Text(
            'Sort by',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(EnumToString.parseCamelCase(_sortBy),
              style: TextStyle(fontSize: 12)),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => SortByDialog());
          },
        ),
        ListTile(
          title: Text(
            'Order by',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(EnumToString.parseCamelCase(_orderBy),
              style: TextStyle(fontSize: 12)),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => OrderByDialog());
          },
        ),
      ],
      color: Colors.white38,
    ).toList();
  }
}

// TODO:
// [ ] Create bloc for sort
// [x] Create dialog box for sort
// [ ] Maybe move the scroll to bloc listener?
// [ ] Maybe no need to refresh when there is no change?
