import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wedlock_admin/Utils/string_const.dart';

class MyDatabase {
  List<Map<String, dynamic>> usersList = [];
  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'Wedlock.db'),
      version: 5,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $TABLE_NAME('
                '$USER_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
                '$NAME TEXT NOT NULL, '
                '$PHONE TEXT UNIQUE NOT NULL, '
                '$EMAIL TEXT UNIQUE NOT NULL, '
                '$DOB TEXT NOT NULL, '
                '$GENDER TEXT CHECK($GENDER IN ("Male", "Female")) NOT NULL, '
                '$CITY TEXT NOT NULL, '
                '$DB_HOBBIES TEXT, '
                '$IS_FAV INTEGER DEFAULT 0, '
                '$AGE INTEGER)'
        );
      },
    );
    return _db!;
  }

  Future<void> addUser(Map<String, dynamic> users) async {
    final _db = await database;
    await _db.insert(TABLE_NAME, users);
    await fetchUsersFromTable();
  }

  Future<void> fetchUsersFromTable() async {
    final _db = await database;
    usersList = await _db.query(TABLE_NAME);
    print('Users: $usersList');
  }

  Future<void> favUser(int id, int isFav) async {
    final _db = await database;
    await _db.update(
      TABLE_NAME,
      {IS_FAV: isFav},
      where: '$USER_ID = ?',
      whereArgs: [id],
    );
    await fetchUsersFromTable();
  }

  Future<void> deleteUser(int id) async {
    final _db = await database;
    await _db.delete(TABLE_NAME,
    where: '$USER_ID = ?',
    whereArgs: [id],
    );
    await fetchUsersFromTable();
  }

  Future<void> editUser(Map<String, dynamic> users,int id) async {
    final _db = await database;
    await _db.update(TABLE_NAME, users,
    where: '$USER_ID = ?',
        whereArgs: [id]);
    await fetchUsersFromTable();
  }



  //region CONSTANTS
  // static const String TABLE_NAME = 'Table_Name';
  // static const String USER_ID = 'UserId';
  // static const String NAME = 'User_Name';
  // static const String EMAIL = 'User_Email';
  // static const String PHONE = 'User_Phone';
  // static const String CITY = 'User_City';
  // static const String DOB = 'User_Dob';
  // static const String HOBBIES = 'User_Hobbies';
  // static const String IS_FAV = 'is_fav';
  // static const String GENDER = 'Gender';
  // static const String AGE = 'age';
//endregion
}
