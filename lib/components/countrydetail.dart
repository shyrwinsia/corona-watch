import 'package:covidwatch/bloc/countrydetailspage/bloc.dart';
import 'package:covidwatch/components/flag.dart';
import 'package:covidwatch/components/graph.dart';
import 'package:covidwatch/data/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryDetailPage extends StatefulWidget {
  final CountryStats countryStats;

  CountryDetailPage({this.countryStats});

  @override
  State<StatefulWidget> createState() => CountryDetailPageState();
}

class CountryDetailPageState extends State<CountryDetailPage> {
  CountryDetailsPageBloc _bloc;
  bool _isSnackbarActive = false;

  @override
  void initState() {
    super.initState();
    _bloc = CountryDetailsPageBloc()
      ..add(LoadCountryDetail(name: widget.countryStats.country));
  }

  @override
  Widget build(BuildContext context) {
    String title = (widget.countryStats.country.length > 25)
        ? widget.countryStats.country.substring(0, 21) + "..."
        : widget.countryStats.country;
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
            Flags.get(widget.countryStats.iso2, height: 14),
            SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          _createWatchListButton(),
        ],
      ),
      body: BlocListener<CountryDetailsPageBloc, CountryDetailsPageState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is AddedToWatchlist) {
            _showSnackbar(context, 'Added to your watchlist');
          } else if (state is RemovedFromWatchlist) {
            _showSnackbar(context, 'Removed from your watchlist');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: CountryGraph(widget.countryStats),
        ),
      ),
    );
  }

  Widget _createWatchListButton() {
    return BlocBuilder<CountryDetailsPageBloc, CountryDetailsPageState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is Loaded) {
            if (!state.inWatchlist) {
              return IconButton(
                icon: Icon(
                  FeatherIcons.eyeOff,
                  size: 20,
                  color: Colors.white.withOpacity(0.6),
                ),
                onPressed: () {
                  if (!_isSnackbarActive) {
                    _bloc
                        .add(AddToWatchlist(name: widget.countryStats.country));
                  }
                },
              );
            } else {
              return IconButton(
                icon: Icon(
                  FeatherIcons.eye,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (!_isSnackbarActive) {
                    _bloc.add(
                        RemoveFromWatchlist(name: widget.countryStats.country));
                  }
                },
              );
            }
          } else
            return Container();
        });
  }

  void _showSnackbar(BuildContext context, String message) {
    if (!_isSnackbarActive) {
      _isSnackbarActive = true;
      Scaffold.of(context)
          .showSnackBar(
            SnackBar(
              backgroundColor: Color(0xFF111111),
              duration: Duration(milliseconds: 1500),
              content: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
          .closed
          .then((SnackBarClosedReason reason) {
        // snackbar is now closed.
        _isSnackbarActive = false;
      });
    }
  }
}
