import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/model/employee.dart';
import 'package:task/model/team.dart';
import 'package:task/routes/route.gr.dart';

class EmployeePage extends StatelessWidget {
  List<Team> teamList = List<Team>();

  @override
  Widget build(BuildContext context) {
    check(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
      ),
      body: FutureBuilder(
        future: initialize(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No data'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          List<Employee> employeeList = snapshot.data;
          if (employeeList.length > 0 && teamList.length > 0) {
            return ListView.builder(
              itemCount: employeeList.length,
              itemBuilder: (context, index) {
                Employee employee = employeeList[index];
                Team team = teamList[index];
                List<Widget> w = List<Widget>();
                if (!employee.isTeamLead)
                  w.add(Text('Team Lead: ${team.tLName}'));
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          employee.name,
                          style: TextStyle(fontSize: 24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Age: ${employee.age}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                            Spacer(),
                            Text('City: ${employee.city}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                          ],
                        ),
                        ...w,
                        Chip(
                          shadowColor: Colors.grey,
                          elevation: 5.0,
                          backgroundColor: Colors.white,
                          label: Text(team.name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text('No Employeees'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ExtendedNavigator.ofRouter<Router>()
              .pushNamed(Routes.addEmployeePage);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void check(BuildContext context) async {
    List<Team> teams = await Team.fetchAll();
    if (teams.length <= 0) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('No Teams Found'),
              content: Text('You should create Team before adding Employee'),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    ExtendedNavigator.ofRouter<Router>()
                        .pushNamed(Routes.teamPage);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
      ExtendedNavigator.ofRouter<Router>().pushNamed(Routes.teamPage);
      Navigator.pop(context);
    }
  }

  Future<List<Employee>> initialize() async {
    List<Employee> empList = await Employee.fetchAll();
    teamList = List<Team>();
    empList.forEach((employee) async {
      Team team = await Team.fetch(employee.teamId);
      teamList.add(team);
    });
    return empList;
  }
}
