import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task/routes/route.gr.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: ExtendedNavigator<Router>(
        router: Router(),
      ),
    );
  }
}
