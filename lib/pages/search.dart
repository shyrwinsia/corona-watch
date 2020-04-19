import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF111111),
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0xff8fa7f4).withOpacity(0.4),
                    ),
                  ),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  autofocus: true,
                  onChanged: (text) {
                    // send this to the bloc as event for processing
                  },
                  decoration: InputDecoration(
                    fillColor: Color(0xff8fa7f4),
                    hintText: 'Search country or territory',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(fontSize: 14),
                    icon: Icon(
                      FeatherIcons.search,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
