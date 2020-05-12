import 'package:flutter/material.dart';
import 'package:task/model/employee.dart';
import 'package:task/model/team.dart';

class AddEmployeePage extends StatelessWidget {
  Map<int, String> tlMap = Map<int, String>();

  AddEmployeePage();

  @override
  Widget build(BuildContext context) {
    String name = '';
    int age = 0;
    String city = '';
    bool isTeamLead = false;
    int tlId;
    int teamId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              Employee emp = Employee(name, age, city, isTeamLead, teamId);
              emp.tlId = tlId;
              emp.debug();
              if (isTeamLead) {
                Team team = await Team.fetch(emp.teamId);
                team.tLName = emp.name;
                team = await Team.update(team);
              }
              emp = await Employee.create(emp);
              emp.debug();
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: initialize(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
            if (teamList.length > 0) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  InputFieldTitle(
                    title: 'Employee Name',
                    hint: 'Enter Name Here',
                    onChanged: (data) {
                      name = data;
                    }, //  get name
                  ),
                  InputFieldTitle(
                    title: 'Age',
                    hint: 'Enter Age',
                    onChanged: (data) {
                      age = int.parse(data);
                    }, //  get age
                  ),
                  InputFieldTitle(
                    title: 'City',
                    hint: 'Enter City',
                    onChanged: (data) {
                      city = data;
                    }, //  get city
                  ),
                  SwitchDropDown(
                    switchTitle: 'Is Team Lead',
                    dropDownTitle: 'Team Lead',
                    dropDownMenuItem: <DropdownMenuItem<int>>[
                      ..._buildDropDownItem(),
                      //  pass Map<tl_id, tl_name>
                    ],
                    onChanged: (x, y) {
                      isTeamLead = x;
                      tlId = y;
                    }, // get value
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Team', style: TextStyle(fontSize: 22)),
                  ),
                  OptionChip(
                    onSelected: (index) {
                      //  get value
                      teamId = teamList[index].id;
                    },
                    children: <Widget>[
                      ..._buildTeam(teamList) //
                    ],
                  ),
                ],
              );
            }
            return Center(
              child: Text('No Team'),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildDropDownItem() {
    List<DropdownMenuItem<int>> widgets = [];
    tlMap.forEach((key, value) {
      widgets.add(DropdownMenuItem<int>(
        value: key,
        child: Text(value, style: TextStyle(fontSize: 18)),
      ));
    });
    return widgets;
  }

  List<Widget> _buildTeam(List<Team> teams) {
    List<Text> widgets = [];
    for (Team team in teams) {
      widgets.add(Text(team.name));
    }
    return widgets;
  }

  Future<List<Team>> initialize() async {
    tlMap = await Employee.fetchTeamLead();
    if (tlMap.length == 0) {
      print('object');
    }
    return Team.fetchAll();
  }
}

class InputFieldTitle extends StatelessWidget {
  final String title;
  final String hint;
  final Function onChanged;

  InputFieldTitle(
      {@required this.title, @required this.hint, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 22),
          ),
          TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchDropDown extends StatefulWidget {
  final String switchTitle;
  final String dropDownTitle;
  final List<DropdownMenuItem<int>> dropDownMenuItem;
  final Function onChanged;

  SwitchDropDown({
    @required this.switchTitle,
    @required this.dropDownTitle,
    @required this.dropDownMenuItem,
    @required this.onChanged,
  });

  @override
  _SwitchDropDownState createState() => _SwitchDropDownState();
}

class _SwitchDropDownState extends State<SwitchDropDown> {
  bool _isChecked = false;
  int _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(widget.switchTitle, style: TextStyle(fontSize: 18)),
            Spacer(),
            Switch(
              value: _isChecked,
              onChanged: (bool value) {
                _isChecked = value;
                if (_isChecked) {
                  this._value = null;
                }
                setState(() {
                  widget.onChanged(value, this._value);
                });
              },
            ),
          ],
        ),
        ...showMystery(_isChecked),
      ],
    );
  }

  List<Widget> showMystery(bool flag) {
    List<Widget> widgets = <Widget>[];
    if (!flag) {
      widgets.add(
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.dropDownTitle, style: TextStyle(fontSize: 22)),
            DropdownButton<int>(
              isExpanded: true,
              value: _value,
              items: widget.dropDownMenuItem,
              onChanged: (int value) {
                this._value = value;
                setState(() {
                  widget.onChanged(_isChecked, value);
                });
              },
            ),
          ],
        ),
      );
    }
    return widgets;
  }
}

class OptionChip extends StatefulWidget {
  final Function onSelected;
  final List<Widget> children;

  const OptionChip({@required this.onSelected, @required this.children});

  @override
  _OptionChipState createState() => _OptionChipState();
}

class _OptionChipState extends State<OptionChip> {
  int _value;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List<Widget>.generate(
          widget.children.length,
          (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(
                  label: widget.children[index],
                  selected: _value == index,
                  onSelected: (selected) {
                    _value = selected ? index : null;
                    if (_value != null) {
                      setState(() {
                        widget.onSelected(index);
                      });
                    }
                  },
                ),
              )),
    );
  }
}
