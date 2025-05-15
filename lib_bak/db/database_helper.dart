import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'rentitem.db'),
      version: 2, // Increment version
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE itemtype (
          type TEXT PRIMARY KEY,
          timer INTEGER,
          price INTEGER
        )
      ''');
        await db.execute('''
        CREATE TABLE item (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT,
          name TEXT,
          FOREIGN KEY(type) REFERENCES itemtype(type) ON DELETE SET NULL
        )
      ''');
        await db.execute('''
        CREATE TABLE rental (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT,
          name TEXT,
          time TEXT,
          date TEXT,
          price INTEGER,
          FOREIGN KEY(name) REFERENCES item(name),
          FOREIGN KEY(type) REFERENCES item(type)
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add km_prices column to events table in version 2
          await db.execute('ALTER TABLE tourpackage ADD COLUMN km_prices TEXT');
        }
      },
    );
  }

  // Fetch all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Fetch by id ???
  Future<List<Map<String, dynamic>>> getUsersById(int id) async {
    final db = await database;
    return await db.query('users', where: 'id = ?', whereArgs: [id]);
  }

// Insert a new registration
  Future<int> insertRegistration(Map<String, dynamic> registrationData) async {
    final db = await database;
    return await db.insert('registrations', registrationData);
  }

  // Fetch registered events for a user
  Future<List<Map<String, dynamic>>> getUserRegisteredPackages(
      String fullname) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT e.name, e.date
      FROM registrations r
      INNER JOIN events e ON r.event_id = e.id
      INNER JOIN users u ON r.user_id = u.id
      WHERE u.fullname = ?
    ''', [fullname]);
  }

  // Insert a new user
  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    return await db.insert('users', userData);
  }

  Future<int> insertAdmin(Map<String, dynamic> adminData) async {
    final db = await database;
    return await db.insert('admin', adminData);
  }

  Future<int> insertTour(Map<String, dynamic> tourData) async {
    final db = await database;
    return await db.insert('tourbook', tourData);
  }

  // Fetch all booking
  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('tourbook');
  }

  // Fetch all tour packages
  Future<List<Map<String, dynamic>>> getPackages() async {
    final db = await database;
    return await db.query('tourpackage');
  }
  
  Future<List<Map<String, dynamic>>> getDomesticPackages() async {
    final db = await database;
    return await db.query('tourpackage', where: 'domestic = ?', whereArgs: [1]);
  }

  Future<List<Map<String, dynamic>>> getInterPackages() async {
    final db = await database;
    return await db.query('tourpackage', where: 'domestic = ?', whereArgs: [0]);
  }

  // Insert a new event
  Future<int> insertPackage(Map<String, dynamic> eventData) async {
    final db = await database;
    return await db.insert('tourpackage', eventData);
  }

  // Update an existing event
  Future<int> updatePackage(int eventId, Map<String, dynamic> eventData) async {
    final db = await database;
    return await db.update(
      'tourpackage',
      eventData,
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  // Delete an event (optional)
  Future<int> deletePackage(int pkgId) async {
    final db = await database;
    return await db.delete('tourpackage', where: 'id = ?', whereArgs: [pkgId]);
  }
}