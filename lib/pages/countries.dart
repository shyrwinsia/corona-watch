import 'package:covidwatch/bloc/countriespage/bloc.dart';
import 'package:covidwatch/components/countrydetail.dart';
import 'package:covidwatch/components/error.dart';
import 'package:covidwatch/components/flag.dart';
import 'package:covidwatch/data/model.dart';
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
    'Dead',
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
  int index = 0;
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
              title: Text(
                "COUNTRIES",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: SizedBox(
                  height: 48,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Country / Territory',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total Cases',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: this.index == index
                              ? TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff8fa7f4),
                                  fontWeight: FontWeight.bold,
                                )
                              : TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6))),
                      onPressed: () {
                        _bloc.add(LoadCountryList(countries: widget.countries));
                        setState(() {
                          this.index = index;
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
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.white38),
      itemBuilder: (BuildContext context, int index) =>
          _buildTile(context, list[index], sortBy),
    );
  }

  Widget _buildTile(BuildContext context, CountryStats stats, SortBy sortBy) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

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
                Text(
                  stats.country,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Text(
              stats.cases.toString().replaceAllMapped(reg, mathFunc),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

//  ListView.builder(
//   physics: ClampingScrollPhysics(),
//   shrinkWrap: true,
//   scrollDirection: Axis.horizontal,
//   itemCount: widget.sortLabels.length,
//   itemBuilder: (BuildContext context, int index) =>
//       FlatButton(
//     child: Text(this.widget.sortLabels[index],
//         style: this.index == index
//             ? TextStyle(
//                 fontSize: 12,
//                 color: Color(0xff8fa7f4),
//                 fontWeight: FontWeight.bold,
//               )
//             : TextStyle(
//                 fontSize: 12,
//                 color: Colors.white.withOpacity(0.6))),
//     onPressed: () {
//       _bloc.add(LoadCountryList(countries: widget.countries));
//       setState(() {
//         this.index = index;
//       });
//     },
//   ),
// ),
