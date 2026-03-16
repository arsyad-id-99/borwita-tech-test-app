import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shop_cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        product_title TEXT NOT NULL,
        product_image TEXT,
        category TEXT,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations untuk Cart
  Future<int> insertCartItem(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('cart', row);
  }

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final db = await instance.database;
    return await db.query('cart', orderBy: 'created_at DESC');
  }
}
