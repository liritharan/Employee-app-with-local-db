import 'package:flutter/material.dart';
import '../model/team.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Future<List<Team>> futureTeamList = Team.fetchAll();




//  1
//  2
//  3 //db  Future<String> =>
//  4
//  5
//  6
//
//
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Teams'),
        ),
        body: FutureBuilder(
          future: futureTeamList,
          builder: (BuildContext context, AsyncSnapshot<List<Team>> snapshot) {

            if (!snapshot.hasData) {
              return Center(
                child: Text('No Data'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            List<Team> teamList = snapshot.data;
            if (teamList.length > 0)
              return ListView.builder(
                itemCount: teamList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          Team team = teamList[index];
                          return EditDialog(
                            name: team.name,
                            edit: (data) async {
                              team.name = data;
                              await Team.update(team);
                              setState(() {
                                futureTeamList = Team.fetchAll();
                              });
                              Navigator.pop(context);
                            },
                            delete: () async {
                              await Team.delete(team.id);
                              setState(() {
                                futureTeamList = Team.fetchAll();
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          teamList[index].name,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              );
            return Center(
              child: Text('No Team'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InputDialog(
                    title: 'Add',
                    onSubmit: (data) {
                      Team team = Team(data);
                      Team.create(team);
                      setState(() {
                        futureTeamList = Team.fetchAll();
                      });
                    },
                  );
                });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class EditDialog extends StatelessWidget {
  final Function edit, delete;
  final String name;

  EditDialog({@required this.edit, @required this.delete, this.name});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Actions'),
        content: Text(
          'Select delete or edit',
          style: TextStyle(fontSize: 22),
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            onPressed: () {
              delete();
            },
            child: Text(
              'DELETE',
              style: TextStyle(color: Colors.teal),
            ),
          ),
          MaterialButton(
            elevation: 5.0,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return InputDialog(
                      name: name,
                      title: 'Edit',
                      onSubmit: (name) {
                        edit(name);
                      });
                },
              );
            },
            child: Text(
              'EDIT',
              style: TextStyle(color: Colors.teal),
            ),
          ),
        ]);
  }
}

class InputDialog extends StatelessWidget {
  final String title;
  final Function onSubmit;
  final String name;

  InputDialog({
    @required this.title,
    @required this.onSubmit,
    this.name = '',
  });

  @override
  Widget build(BuildContext context) {
    String input = '';
    return AlertDialog(
      title: Text('$title Team'),
      content: TextField(
        onChanged: (String data) {
          input = data;
        },
        controller: TextEditingController(text: this.name),
        decoration: InputDecoration(hintText: 'Enter Name Here'),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(color: Colors.teal),
          ),
        ),
        MaterialButton(
          elevation: 5.0,
          onPressed: () {
            input = input.trim();
            if (input.isNotEmpty && input.length >= 2 && input.length <= 15) {
              onSubmit(input);
              Navigator.pop(context);
            }
          },
          child: Text(
            title.toUpperCase(),
            style: TextStyle(color: Colors.teal),
          ),
        )
      ],
    );
  }
}
