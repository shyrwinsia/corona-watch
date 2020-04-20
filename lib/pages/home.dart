import 'package:covidwatch/bloc/homepage/bloc.dart';
import 'package:covidwatch/components/error.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/pages/countries.dart';
import 'package:covidwatch/pages/summary.dart';
import 'package:covidwatch/pages/watchlist.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget with ErrorMixin {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

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
        if (state is Loading) {
          return _buildLoading();
        } else if (state is Loaded) {
          return _buildBody(state.stats);
        } else if (state is Wtf) {
          return _buildError(
            widget.buildError(
              cause: state.exception.cause,
              action: state.exception.action,
            ),
          );
        } else {
          return _buildError(
            widget.buildError(
              cause: 'Something went wrong',
              action: 'Please restart app',
            ),
          );
        }
      },
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      body: Center(
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
      ),
    );
  }

  Widget _buildError(Widget error) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(FeatherIcons.refreshCw),
              iconSize: 16,
              onPressed: () => _bloc.add(LoadGlobalStats())),
        ],
      ),
      body: error,
    );
  }

  Widget _buildBody(AppModel stats) {
    return Scaffold(
      body: [
        SummaryPage(stats.globalStats, _bloc),
        WatchlistPage(stats.countryList),
        CountriesPage(stats.countryList),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xff8fa7f4),
        unselectedItemColor: Colors.white.withOpacity(0.6),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: pages.map((Page page) {
          return BottomNavigationBarItem(
            icon: Icon(page.icon, size: 18),
            title: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                page.title,
                style: TextStyle(fontSize: 10),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Page {
  const Page(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<Page> pages = <Page>[
  Page('Summary', FeatherIcons.barChart2),
  Page('Watchlist', FeatherIcons.eye),
  Page('World Tally', FeatherIcons.globe),
];
