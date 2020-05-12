// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/pages/team_page.dart';
import 'package:task/pages/employee_page.dart';
import 'package:task/pages/add_employee.dart';

abstract class Routes {
  static const homePage = '/';
  static const teamPage = '/team-page';
  static const employeePage = '/employee-page';
  static const addEmployeePage = '/add-employee-page';
}

class Router extends RouterBase {
  //This will probably be removed in future versions
  //you should call ExtendedNavigator.ofRouter<Router>() directly
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case Routes.teamPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => TeamPage(),
          settings: settings,
        );
      case Routes.employeePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmployeePage(),
          settings: settings,
        );
      case Routes.addEmployeePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddEmployeePage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
