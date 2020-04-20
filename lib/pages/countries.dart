import 'package:covidwatch/bloc/countriespage/bloc.dart';
import 'package:covidwatch/components/error.dart';
import 'package:covidwatch/components/flag.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/pages/countrydetail.dart';
import 'package:covidwatch/pages/search.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesPage extends StatefulWidget with ErrorMixin {
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

  CountriesPage(this.countries);
  @override
  State<StatefulWidget> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  int _sortBy = 0;
  int _orderBy = 0;
  CountriesPageBloc _bloc;

  final ScrollController _scroller = ScrollController();

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
              title: Text(
                "WORLD TALLY",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                  icon: Icon(FeatherIcons.search),
                  iconSize: 16,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(widget.countries),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
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
                            _bloc.add(OrderCountryList(
                                orderBy: OrderBy.values[_orderBy]));
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
              ),
            ),
            body: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: <Widget>[
                _buildBody(context, state),
                Container(
                  height: 40,
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.sortLabels.length,
                    itemBuilder: (BuildContext context, int index) =>
                        FlatButton(
                      child: Text(this.widget.sortLabels[index],
                          style: this._sortBy == index
                              ? TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff8fa7f4),
                                  fontWeight: FontWeight.bold,
                                )
                              : TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6))),
                      onPressed: () {
                        _bloc
                            .add(SortCountryList(sortBy: SortBy.values[index]));
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
              ],
            ));
      },
    );
  }

  Widget _buildBody(BuildContext context, CountriesPageState state) {
    if (state is Uninitialized) {
      return Container();
    } else if (state is Loaded) {
      return _buildCountriesList(context, state.countries.list);
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
      padding: EdgeInsets.symmetric(horizontal: 16),
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
      ),
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
