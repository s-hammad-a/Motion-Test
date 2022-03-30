import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection._init();

  static Database? _database;

  DatabaseConnection._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'TEXT PRIMARY KEY';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE devices ( 
      deviceId $idType,
      deviceName $textType,
      button1 $textType, 
      button2 $textType, 
      button3 $textType, 
      button4 $textType, 
      button5 $textType,
      ipAddress $textType
    )
''');
  }

  Future<int> create(String deviceId, String name, List<String> buttons, String ipAddress) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

      try {
      final id = await db.insert('devices', {
        'deviceId' : deviceId,
        'deviceName': name,
        'button1': buttons[0],
        'button2': buttons[1],
        'button3': buttons[2],
        'button4': buttons[3],
        'button5': buttons[4],
        'ipAddress': ipAddress,
      });
      return id;
    }
    catch (ex) {
        print(ex);
    }
    return 0;
  }

  Future<dynamic> readDevices(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'devices',
      columns: ['deviceName', 'button1', 'button2', 'button3', 'button4', 'button5', 'ipAddress'],
      where: 'deviceId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return {
        'deviceName' : maps.first['deviceName'],
        'button1' : maps.first['button1'],
        'button2' : maps.first['button2'],
        'button3' : maps.first['button3'],
        'button4' : maps.first['button4'],
        'button5' : maps.first['button5'],
        'ipAddress' : maps.first['ipAddress'],
      };
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<dynamic> readDevice() async {
    try
    {
      final db = await instance.database;
      final maps = await db.query(
        'devices',
        columns: [
          'deviceId',
          'deviceName',
          'button1',
          'button2',
          'button3',
          'button4',
          'button5',
          'ipAddress'
        ],
      );
      if (maps.isNotEmpty) {
        return {
          'deviceId' : maps.first['deviceId'],
          'deviceName' : maps.first['deviceName'],
          'button1' : maps.first['button1'],
          'button2' : maps.first['button2'],
          'button3' : maps.first['button3'],
          'button4' : maps.first['button4'],
          'button5' : maps.first['button5'],
          'ipAddress' : maps.first['ipAddress'],
        };
      } else {
        return {'deviceName' : 'empty'};
      }
    }
    catch (ex) {
      print(ex);
      return {'deviceName' : 'empty2'};
    }
  }

  Future<dynamic> readAllDevices() async {
    final db = await instance.database;

    final orderBy = 'deviceId ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query('devices', orderBy: orderBy);

    return result;
  }

  Future<int> update(String id, String name, List<String> buttons, String ipAddress) async {
    final db = await instance.database;
    return db.update(
      'devices',
      {
        'deviceName' : name,
        'button1' : buttons[0],
        'button2' : buttons[1],
        'button3' : buttons[2],
        'button4' : buttons[3],
        'button5' : buttons[4],
        'ipAddress' : ipAddress,
      },
      where: 'deviceId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      'devices',
      where: 'deviceId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleted() async {
    final db = await instance.database;
    return await db.delete(
      'devices',
      where: 'deviceName = ?',
      whereArgs: ['30AEA4Board'],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}