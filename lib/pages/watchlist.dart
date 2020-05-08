import 'package:covidwatch/bloc/watchlistpage/bloc.dart';
import 'package:covidwatch/components/error.dart';
import 'package:covidwatch/components/flag.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/pages/countrydetail.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget with ErrorMixin {
  final CountryList countries;
  final List<String> sortLabels = [
    'Total cases',
    'Mild / Moderate',
    'Severe / Critical',
    'Recovered',
    'Deaths',
    'New cases',
    'New deaths',
    'Cases per million',
    'Deaths per million',
    'Tests per million',
    'Tests conducted',
    'Alphabetical',
  ];

  WatchlistPage(this.countries);
  @override
  State<StatefulWidget> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  int _sortBy = 0;
  int _orderBy = 0;
  WatchlistPageBloc _bloc;

  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = WatchlistPageBloc()
      ..add(LoadCountryList(countries: widget.countries));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistPageBloc, WatchlistPageState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(state),
          body: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              _buildBody(context, state),
              _buildSortOptions(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(WatchlistPageState state) {
    if (state is Loaded) {
      if (state.countries.list.length > 0)
        return AppBar(
          title: Text(
            "WATCHLIST",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: _buildHeader(),
        );
      else
        return AppBar(
          title: Text(
            "WATCHLIST",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        );
    } else
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );
  }

  Widget _buildSortOptions(WatchlistPageState state) {
    if (state is Loaded) {
      if (state.countries.list.length > 0)
        return Container(
          height: 40,
          color: Colors.black,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.sortLabels.length,
            itemBuilder: (BuildContext context, int index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: FlatButton(
                color: this._sortBy == index
                    ? Color(0xff8fa7f4).withOpacity(0.6)
                    : Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  this.widget.sortLabels[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _bloc.add(SortCountryList(sortBy: SortBy.values[index]));
                  setState(() {
                    this._sortBy = index;
                    _scroller.animateTo(
                      0.0,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 1000),
                    );
                  });
                },
              ),
            ),
          ),
        );
      else
        return Container();
    } else
      return Container();
  }

  Widget _buildHeader() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: SizedBox(
        height: 40,
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('COUNTRY / TERRITORY',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              InkWell(
                onTap: () {
                  setState(() {
                    if (_orderBy == 0)
                      this._orderBy = 1;
                    else
                      this._orderBy = 0;
                  });
                  _bloc
                      .add(OrderCountryList(orderBy: OrderBy.values[_orderBy]));
                  _scroller.animateTo(
                    0.0,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 1000),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.sortLabels[_sortBy].toUpperCase(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      (_orderBy == 0)
                          ? Icon(
                              FeatherIcons.arrowDownCircle,
                              size: 14,
                              color: Colors.white.withOpacity(0.6),
                            )
                          : Icon(
                              FeatherIcons.arrowUpCircle,
                              size: 14,
                              color: Colors.white.withOpacity(0.6),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WatchlistPageState state) {
    if (state is Uninitialized) {
      return Container();
    } else if (state is Loaded) {
      if (state.countries.list.length > 0)
        return _buildCountriesList(context, state.countries.list);
      else
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FeatherIcons.eyeOff,
                size: 48,
                color: Color(0x44ffffff),
              ),
              SizedBox(height: 14),
              Text(
                'Your watchlist is empty',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 2),
              Text(
                'Go to a country and tap on the eye icon to add',
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    } else if (state is Wtf) {
      return widget.buildError(
        cause: state.exception.cause,
        action: state.exception.action,
      );
    } else {
      return widget.buildError(
        cause: 'Something went wrong',
        action: 'Please restart app',
      );
    }
  }

  Widget _buildCountriesList(BuildContext context, List list) {
    return ListView.separated(
      controller: _scroller,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 48),
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.white38),
      itemBuilder: (BuildContext context, int index) =>
          _buildTile(context, list[index]),
    );
  }

  Widget _buildTile(BuildContext context, CountryStats stats) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountryDetailPage(countryStats: stats),
        ),
      ).then((onValue) {
        _bloc.add(LoadCountryList(countries: widget.countries));
      }),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
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
            _buildStat(stats),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(CountryStats stats) {
    String stat;

    if (_sortBy == 0)
      stat = _convert(stats.cases);
    else if (_sortBy == 1)
      stat = _convert(stats.mild);
    else if (_sortBy == 2)
      stat = _convert(stats.critical);
    else if (_sortBy == 3)
      stat = _convert(stats.recovered);
    else if (_sortBy == 4)
      stat = _convert(stats.deaths);
    else if (_sortBy == 5)
      stat = _convert(stats.todayCases);
    else if (_sortBy == 6)
      stat = _convert(stats.todayDeaths);
    else if (_sortBy == 7)
      stat = _convert(stats.casesPerMillion);
    else if (_sortBy == 8)
      stat = _convert(stats.deathsPerMillion);
    else if (_sortBy == 9)
      stat = _convert(stats.testsPerMillion);
    else if (_sortBy == 10)
      stat = _convert(stats.tests);
    else
      stat = '';

    return Text(
      stat,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _convert(num number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return number.toString().replaceAllMapped(reg, mathFunc);
  }

  @override
  void dispose() {
    super.dispose();
    _scroller.dispose();
  }
}
