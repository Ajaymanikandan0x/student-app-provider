import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_app_provider/data_base/model/model.dart';

class DatabaseHelper {
  static const _databaseName = 'student.db';
  static const _databaseVersion = 1;
  static const table = 'students';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnBatch = 'batch';
  static const columnAge = 'age';
  static const columnStudentId = 'studentId';
  static const columnProfileImg = 'profileImg';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnBatch TEXT NOT NULL,
        $columnAge INTEGER NOT NULL,
        $columnStudentId INTEGER NOT NULL,
        $columnProfileImg TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertStudent(Model student) async {
    try {
      final db = await database;
      int id = await db.insert(table, {
        columnName: student.name,
        columnAge: student.age,
        columnBatch: student.batch,
        columnStudentId: student.studentId,
        columnProfileImg: student.profileImg,
      });
      print("Student inserted successfully with id: $id");
      return id;
    } catch (e) {
      print("Error inserting student: $e");
      return -1; // or any other error code you prefer
    }
  }

  Future<List<Model>> getStudents() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(table);

      print("Fetched ${maps.length} students from the database");

      List<Model> students = List.generate(
        maps.length,
        (index) => Model(
          id: maps[index][columnId],
          name: maps[index][columnName],
          batch: maps[index][columnBatch],
          age: maps[index][columnAge],
          studentId: maps[index][columnStudentId],
          profileImg: maps[index][columnProfileImg],
        ),
      );

      print("Generated list of students:");
      for (var student in students) {
        print(student);
      }

      return students;
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId=?',
      whereArgs: [id],
    );
  }

  Future<int> updateStudent(Model student) async {
    final db = await database;
    return await db.update(
      table,
      {
        columnName: student.name,
        columnAge: student.age,
        columnBatch: student.batch,
        columnStudentId: student.studentId,
        columnProfileImg: student.profileImg,
      },
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }
}
