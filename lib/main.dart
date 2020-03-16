import 'package:covidwatch/bloc/blocdelegate.dart';
import 'package:covidwatch/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // applying bloc delegate to override the transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(CovidWatch());
  });
}

class CovidWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arimo',
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
