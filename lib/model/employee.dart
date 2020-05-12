import 'package:sqflite/sqflite.dart';
import 'package:task/database/database.dart';

class Employee {
  int id;
  int age;
  int teamId;
  int tlId;
  String name;
  String city;
  bool isTeamLead;

  Employee(this.name, this.age, this.city, this.isTeamLead, this.teamId);


  static Employee fromMap(Map<String, dynamic> map) {
    bool isTl = map['is_tl'] == 0 ? false : true;
    Employee employee = Employee(
      map['name'],
      map['age'],
      map['city'],
      isTl,
      map['team_id'],
    );
    employee.id = map['id'];
    employee.tlId = map['tl_id'];
    return employee;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['age'] = age;
    map['city'] = city;
    map['is_tl'] = isTeamLead;
    map['team_id'] = teamId;
    map['tl_id'] = tlId;
    return map;
  }

  void debug() {
    Map<String, dynamic> map = this.toMap();
    map['id'] = this.id;
    print(map);
  }

  static Future<List<Employee>> fetchAll() async {
    Database db = await DatabaseProvider.db.database;
    var employees = await db.query(
      DatabaseProvider.memberTable,
      columns: [
        DatabaseProvider.memberPKColumn,
        DatabaseProvider.memberNameColumn,
        DatabaseProvider.memberAgeColumn,
        DatabaseProvider.memberCityColumn,
        DatabaseProvider.memberIsTlColumn,
        DatabaseProvider.memberTeamIdColumn,
        DatabaseProvider.memberTlIdColumn
      ],
    );
    List<Employee> employeeList = List<Employee>();
    employees.forEach((map) {
      employeeList.add(Employee.fromMap(map));
    });
    return employeeList;
  }

  static Future<Employee> fetch(int id) async {
    Database db = await DatabaseProvider.db.database;
    var employees = await db.query(
      DatabaseProvider.memberTable,
      columns: [
        DatabaseProvider.memberPKColumn,
        DatabaseProvider.memberNameColumn,
        DatabaseProvider.memberAgeColumn,
        DatabaseProvider.memberCityColumn,
        DatabaseProvider.memberIsTlColumn,
        DatabaseProvider.memberTeamIdColumn,
        DatabaseProvider.memberTlIdColumn
      ],
      where: '${DatabaseProvider.memberPKColumn} = $id',
      limit: 1,
    );
    List<Employee> employeeList = List<Employee>();
    employees.forEach((map) {
      employeeList.add(Employee.fromMap(map));
    });
    return employeeList[0];
  }

  static Future<Employee> create(Employee employee) async {
    Database db = await DatabaseProvider.db.database;
    employee.id =
        await db.insert(DatabaseProvider.memberTable, employee.toMap());
    return employee;
  }

  static Future<Employee> update(Employee employee) async {
    Database db = await DatabaseProvider.db.database;
    await db.update(
      DatabaseProvider.memberTable,
      employee.toMap(),
      where: '${DatabaseProvider.memberPKColumn} = ${employee.id}',
    );
    Employee updatedEmployee = await Employee.fetch(employee.id);
    return updatedEmployee;
  }

  static Future delete(int id) async {
    Database db = await DatabaseProvider.db.database;
    db.delete(
      DatabaseProvider.memberTable,
      where: '${DatabaseProvider.memberPKColumn} = $id',
    );
  }

  static Future<Map<int, String>> fetchTeamLead() async {
    Database db = await DatabaseProvider.db.database;
    var employees = await db.query(DatabaseProvider.memberTable,
        columns: [
          DatabaseProvider.memberPKColumn,
          DatabaseProvider.memberNameColumn,
          DatabaseProvider.memberAgeColumn,
          DatabaseProvider.memberCityColumn,
          DatabaseProvider.memberIsTlColumn,
          DatabaseProvider.memberTeamIdColumn,
          DatabaseProvider.memberTlIdColumn
        ],
        where: '${DatabaseProvider.memberIsTlColumn} = 1');
    Map<int, String> tlMap = Map<int, String>();
    employees.forEach((map) {
      tlMap[map['id']] = map['name'];
    });
    return tlMap;
  }
}
