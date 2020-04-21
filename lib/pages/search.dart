import 'package:covidwatch/bloc/searchpage/bloc.dart';
import 'package:covidwatch/components/flag.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/pages/countrydetail.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  final CountryList countries;

  SearchPage(this.countries);
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchPageBloc()..add(LoadSearchPage(countries: widget.countries));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              _buildList(context),
              _buildSearchbar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return BlocBuilder<SearchPageBloc, SearchPageState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is Loaded) {
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 58, 16, 0),
            itemCount: state.countries.list.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.white38),
            itemBuilder: (BuildContext context, int index) =>
                _buildTile(context, state.countries.list[index]),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSearchbar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8, right: 14),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: Icon(FeatherIcons.chevronLeft),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                  color: Color(0xFF333333),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  )),
              child: TextField(
                style: TextStyle(fontSize: 16),
                autofocus: true,
                onChanged: (text) {
                  // send this to the bloc as event for processing
                  _bloc.add(SearchCountry(name: text));
                },
                keyboardType: TextInputType.text,
                keyboardAppearance: Brightness.light,
                cursorColor: Color(0xff8fa7f4),
                decoration: InputDecoration(
                  fillColor: Color(0xff8fa7f4),
                  focusColor: Color(0xff8fa7f4),
                  hoverColor: Color(0xff8fa7f4),
                  hintText: 'Search country or territory',
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, CountryStats stats) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountryDetailPage(countryStats: stats),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flags.get(stats.iso2),
                SizedBox(
                  width: 8,
                ),
                Text(stats.country,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(0.8))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
