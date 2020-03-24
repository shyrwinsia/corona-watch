import 'package:covidwatch/components/countrydetail.dart';
import 'package:covidwatch/components/error.dart';
import 'package:covidwatch/data/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:covidwatch/bloc/countriespage/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covidwatch/pages/sort.dart';

class CountriesPage extends StatefulWidget with ErrorMixin {
  final CountryList countries;

  CountriesPage(this.countries);
  @override
  State<StatefulWidget> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final ScrollController _scroller = ScrollController();
  CountriesPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CountriesPageBloc()
      ..add(LoadCountryList(countries: widget.countries));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesPageBloc, CountriesPageState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(FeatherIcons.chevronLeft),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "COUNTRIES",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Text('Sort'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SortPage()),
                ).then(
                  (value) {
                    _bloc.add(LoadCountryList(countries: widget.countries));
                    _scroller.animateTo(0,
                        duration: Duration(milliseconds: 2000),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                ),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CountriesPageState state) {
    if (state is Uninitialized) {
      return Container();
    } else if (state is Loading) {
      return _buildLoading();
    } else if (state is Loaded) {
      return _buildCountriesList(context, state.countries.list, state.sortBy);
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

  Widget _buildCountriesList(BuildContext context, List list, SortBy sortBy) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16),
      controller: _scroller,
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.white38),
      itemBuilder: (BuildContext context, int index) =>
          _buildTile(context, list[index], sortBy),
    );
  }

  Widget _buildLoading() {
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
            'Loading countries',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, CountryStats stats, SortBy sortBy) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountryDetailPage(countryStats: stats),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              stats.country,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _buildStats(stats, sortBy),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStats(CountryStats stats, SortBy sortBy) {
    switch (sortBy) {
      case SortBy.total:
      case SortBy.alphabetical:
        return [
          _buildTotal(stats.cases),
          _buildActive(stats.active, stats.todayCases),
          _buildDeaths(stats.deaths, stats.todayDeaths),
          _buildRecovered(stats.recovered),
        ];
      case SortBy.active:
      case SortBy.todayActive:
        return [
          _buildActive(stats.active, stats.todayCases),
          _buildDeaths(stats.deaths, stats.todayDeaths),
          _buildRecovered(stats.recovered),
          _buildTotal(stats.cases),
        ];
      case SortBy.deaths:
      case SortBy.todayDeaths:
        return [
          _buildDeaths(stats.deaths, stats.todayDeaths),
          _buildRecovered(stats.recovered),
          _buildActive(stats.active, stats.todayCases),
          _buildTotal(stats.cases),
        ];
      case SortBy.recovered:
        return [
          _buildRecovered(stats.recovered),
          _buildActive(stats.active, stats.todayCases),
          _buildDeaths(stats.deaths, stats.todayDeaths),
          _buildTotal(stats.cases),
        ];
      default:
        return [];
    }
  }

  Widget _buildStat(String label, int base, int increase, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (increase != 0)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    _convert(base),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    FeatherIcons.arrowUp,
                    size: 10,
                  ),
                  Text(
                    "${_convert(increase)}",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              )
            : Text(
                _convert(base),
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: color),
        ),
      ],
    );
  }

  String _convert(int num) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return num.toString().replaceAllMapped(reg, mathFunc);
  }

  @override
  void dispose() {
    super.dispose();
    _scroller.dispose();
  }

  Widget _buildTotal(cases) =>
      _buildStat('Total Cases', cases, 0, Colors.white.withOpacity(0.8));

  Widget _buildActive(active, todayCases) => _buildStat(
      'Active', active, todayCases, Color(0xfff5c76a).withOpacity(0.8));

  Widget _buildDeaths(deaths, todayDeaths) => _buildStat(
      'Deaths', deaths, todayDeaths, Color(0xffff653b).withOpacity(0.8));

  Widget _buildRecovered(recovered) =>
      _buildStat('Recovered', recovered, 0, Color(0xff9ff794).withOpacity(0.8));
}

// TODO
// - idea: move the sort params to root and just let it be propagated?
// - sort the main list? so there is no flicker when loading?
