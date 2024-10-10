import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/modelclass.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE cart(id TEXT PRIMARY KEY, name TEXT, price REAL)');
      },
    );
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('cart', product.toJson());
  }

  Future<List<Product>> getCartProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<void> deleteProductFromCart(String id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }
}
