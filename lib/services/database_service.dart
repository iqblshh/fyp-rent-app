import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is access
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store itemtypes
  // and a table to store rentitems.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {itemtypes} TABLE statement on the database.
    await db.execute('''
      CREATE TABLE itemtypes(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          timer INTEGER, 
          price INTEGER
      )
    ''');
    // Run the CREATE {rentitems} TABLE statement on the database.
    await db.execute('''
      CREATE TABLE rentitems(
          id INTEGER PRIMARY KEY, 
          name TEXT,
          itemtypeId INTEGER, 
          FOREIGN KEY (itemtypeId) REFERENCES itemtypes(id) ON DELETE SET NULL
      )
    ''');
    // CREATE {rental}
    await db.execute('''
      CREATE TABLE rentals(
          id INTEGER PRIMARY KEY,
          rentitemId INTEGER,
          itemType TEXT, 
          itemName TEXT, 
          statime TEXT, 
          endtime TEXT, 
          latetime TEXT, 
          date TEXT, 
          price INTEGER,
          paid INTEGER, 
          status INTEGER, 
          FOREIGN KEY (rentitemID) REFERENCES rentitems(id) ON DELETE SET NULL
      )
    ''');
  }

  // Define a function that inserts itemtypes into the database
  Future<void> insertItemType(ItemType itemtype) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the ItemType into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same itemtype is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'itemtypes',
      itemtype.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertRentItem(RentItem rentitem) async {
    final db = await _databaseService.database;
    await db.insert(
      'rentitems',
      rentitem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertRental(Rental rental) async {
    final db = await _databaseService.database;
    await db.insert(
      'rentals',
      rental.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // A method that retrieves all the itemtypes from the itemtypes table.
  Future<List<ItemType>> itemtypes() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the ItemTypes.
    final List<Map<String, dynamic>> maps = await db.query('itemtypes');

    // Convert the List<Map<String, dynamic> into a List<ItemType>.
    return List.generate(maps.length, (index) => ItemType.fromMap(maps[index]));
  }

  Future<ItemType> itemtype(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('itemtypes', where: 'id = ?', whereArgs: [id]);
    return ItemType.fromMap(maps[0]);
  }

  Future<List<RentItem>> rentitems() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('rentitems');
    return List.generate(maps.length, (index) => RentItem.fromMap(maps[index]));
  }

  Future<List<Rental>> rentals() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('rentals', orderBy: 'id DESC');
    return List.generate(maps.length, (index) => Rental.fromMap(maps[index]));
  }

  // A method that updates a itemtype data from the itemtypes table.
  Future<void> updateItemType(ItemType itemtype) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given itemtype
    await db.update(
      'itemtypes',
      itemtype.toMap(),
      // Ensure that the ItemType has a matching id.
      where: 'id = ?',
      // Pass the ItemType's id as a whereArg to prevent SQL injection.
      whereArgs: [itemtype.id],
    );
  }

  Future<void> updateRentItem(RentItem rentitem) async {
    final db = await _databaseService.database;
    await db.update('rentitems', rentitem.toMap(), where: 'id = ?', whereArgs: [rentitem.id]);
  }

  Future<void> updateRentalStatus(int id, int status) async {
    final db = await _databaseService.database;
    //await db.update('rentals', rental.toMap(), where: 'id = ?', whereArgs: [rental.id]);
    await db.update('rentals', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateRentalPaid(int id, int paid) async {
    final db = await _databaseService.database;
    //await db.update('rentals', rental.toMap(), where: 'id = ?', whereArgs: [rental.id]);
    await db.update('rentals', {'paid': paid}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateRentalTime(int id, String latetime) async {
    final db = await _databaseService.database;
    //await db.update('rentals', rental.toMap(), where: 'id = ?', whereArgs: [rental.id]);
    await db.update('rentals', {'latetime': latetime}, where: 'id = ?', whereArgs: [id]);
  }

  // A method that deletes a itemtype data from the itemtypes table.
  Future<void> deleteItemType(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the ItemType from the database.
    await db.delete(
      'itemtypes',
      // Use a `where` clause to delete a specific itemtype.
      where: 'id = ?',
      // Pass the ItemType's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteRentItem(int id) async {
    final db = await _databaseService.database;
    await db.delete('rentitems', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteRental(int id) async {
    final db = await _databaseService.database;
    await db.delete('rentals', where: 'id = ?', whereArgs: [id]);
  }
}
