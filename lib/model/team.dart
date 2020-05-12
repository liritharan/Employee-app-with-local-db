import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

class Team {
  int id;
  String name;
  int teamLeaderId;
  String tLName;

  Team(this.name);

  Team._withTL(this.name, this.teamLeaderId);

  static Team fromMap(Map<String, dynamic> map) {
    Team team = Team(map['name']);
    team.id = map['id'];
    team.teamLeaderId = map['tl_id'];
    team.tLName = map['tl_name'];
    return team;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = this.name;
    map['tl_id'] = this.teamLeaderId;
    map['tl_name'] = this.tLName;
    return map;
  }

  void debug() {
    Map<String, dynamic> map = this.toMap();
    map['id'] = this.id;
    print(map);
  }

  static Future<List<Team>> fetchAll() async {
    Database db = await DatabaseProvider.db.database;
    var teams = await db.query(
      DatabaseProvider.teamTable,
      columns: [
        DatabaseProvider.teamPKColumn,
        DatabaseProvider.teamNameColumn,
        DatabaseProvider.teamLeadIdColumn,
        DatabaseProvider.teamLeadNameColumn
      ],
    );
    List<Team> teamList = List<Team>();
    teams.forEach((map) {
      teamList.add(Team.fromMap(map));
    });
    return teamList;
  }

  static Future<Team> fetch(int id) async {
    Database db = await DatabaseProvider.db.database;
    var teams = await db.query(
      DatabaseProvider.teamTable,
      columns: [
        DatabaseProvider.teamPKColumn,
        DatabaseProvider.teamNameColumn,
        DatabaseProvider.teamLeadIdColumn,
        DatabaseProvider.teamLeadNameColumn
      ],
      where: '${DatabaseProvider.teamPKColumn} = $id',
      limit: 1,
    );
    List<Team> teamList = List<Team>();
    teams.forEach((map) {
      teamList.add(Team.fromMap(map));
    });
    return teamList[0];
  }

  static Future<Team> create(Team team) async {
    Database db = await DatabaseProvider.db.database;
    team.id = await db.insert(DatabaseProvider.teamTable, team.toMap());
    return team;
  }

  static Future<Team> update(Team team) async {
    Database db = await DatabaseProvider.db.database;
    await db.update(
      DatabaseProvider.teamTable,
      team.toMap(),
      where: '${DatabaseProvider.teamPKColumn} = ${team.id}',
    );
    Team updatedTeam = await Team.fetch(team.id);
    return updatedTeam;
  }

  static Future delete(int id) async {
    Database db = await DatabaseProvider.db.database;
    db.delete(
      DatabaseProvider.teamTable,
      where: '${DatabaseProvider.teamPKColumn} = $id',
    );
  }
}
