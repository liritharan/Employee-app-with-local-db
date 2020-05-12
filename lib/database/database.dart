import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String teamTable = 'teams';
  static const String teamPKColumn = 'id';
  static const String teamNameColumn = 'name';
  static const String teamLeadIdColumn = 'tl_id';
  static const String teamLeadNameColumn = 'tl_name';

  static const String memberTable = 'members';
  static const String memberPKColumn = 'id';
  static const String memberNameColumn = 'name';
  static const String memberAgeColumn = 'age';
  static const String memberCityColumn = 'city';
  static const String memberTeamIdColumn = 'team_id';
  static const String memberIsTlColumn = 'is_tl';
  static const String memberTlIdColumn = 'tl_id';

  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'task.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(
          'CREATE TABLE $teamTable('
          '$teamPKColumn INTEGER PRIMARY KEY,'
          '$teamNameColumn TEXT,'
          '$teamLeadIdColumn INTEGER,'
          '$teamLeadNameColumn TEXT'
          ');',
        );
        await database.execute(
          'CREATE TABLE $memberTable('
          '$memberPKColumn INTEGER PRIMARY KEY,'
          '$memberNameColumn TEXT,'
          '$memberAgeColumn INTEGER,'
          '$memberCityColumn TEXT,'
          '$memberTeamIdColumn INTEGER,'
          '$memberIsTlColumn INTEGER,'
          '$memberTlIdColumn INTEGER'
          ');',
        );
      },
    );
  }
}
