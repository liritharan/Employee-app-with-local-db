import 'package:auto_route/auto_route_annotations.dart';
import 'package:task/pages/add_employee.dart';
import 'package:task/pages/employee_page.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/pages/team_page.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomePage homePage;
  TeamPage teamPage;
  EmployeePage employeePage;
  AddEmployeePage addEmployeePage;
}
//flutter packages pub run build_runner build