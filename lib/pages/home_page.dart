import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task/routes/route.gr.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeItem(
            text: 'Team',
            onTap: () {
              ExtendedNavigator.ofRouter<Router>().pushNamed(Routes.teamPage);
            },
          ),
          HomeItem(
            text: 'Employees',
            onTap: () {
              ExtendedNavigator.ofRouter<Router>()
                  .pushNamed(Routes.employeePage);
            },
          ),
        ],
      ),
    );
  }
}

class HomeItem extends StatelessWidget {
  final String text;
  final Function onTap;

  HomeItem({@required this.text, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24, 16, 8),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Spacer(),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
