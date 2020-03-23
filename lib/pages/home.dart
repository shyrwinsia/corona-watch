import 'package:covidwatch/bloc/homepage/bloc.dart';
import 'package:covidwatch/components/error.dart';
import 'package:covidwatch/components/graph.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/pages/countries.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget with ErrorMixin {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomePageBloc()..add(LoadGlobalStats());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              "COVID WATCH",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              if (state is Loaded || state is Wtf)
                IconButton(
                    icon: Icon(FeatherIcons.refreshCw),
                    iconSize: 16,
                    onPressed: () =>
                        _bloc.add(LoadGlobalStats())), // the fetch event here
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomePageState state) {
    if (state is Loading) {
      return _buildLoading();
    } else if (state is Loaded) {
      return _buildGlobalStats(state.stats);
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
            'Fetching latest updates',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 2),
          Text(
            'Source: worldometers.info',
            style:
                TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalStats(CovidStats stats) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GlobalGraph(stats.globalStats),
        // TODO: Replace with a tab
        // FlatButton(
        //   padding: EdgeInsets.all(0),
        //   child: Text('View countries',
        //       style: TextStyle(color: Color(0xff8fa7f4))),
        //   onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CountriesPage(stats.countryList))),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

// [x] change circular progress color
// [x] change refresh to button
// [x] make the manual refresh work
// [x] black splash screen
// [x] error for no connection
// [x] prevent landscape
// [x] make private function
// [x] add countries
// [x] implement sort: total cases, alphabetical, new cases today, new deaths today
// [x] goddamn clean yo dirty code
// [-] add bloc to code
