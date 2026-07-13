import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/account.dart';

/// 数据库助手类
///
/// 使用 sqflite 实现本地 SQLite 数据库的增删改查。
/// 数据库文件以明文形式存储在应用私有目录中，无任何加密保护。
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  /// 获取数据库实例（单例）
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'passwords.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// 创建表结构
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        siteName TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        customFields TEXT
      )
    ''');
  }

  // ============================================================
  // CRUD 操作
  // ============================================================

  /// 新增一条账号密码记录
  Future<int> insert(Account account) async {
    final db = await database;
    return await db.insert('accounts', account.toMap());
  }

  /// 查询所有记录
  Future<List<Account>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      orderBy: 'id DESC',
    );
    return maps.map((map) => Account.fromMap(map)).toList();
  }

  /// 按 ID 查询单条记录
  Future<Account?> getById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Account.fromMap(maps.first);
  }

  /// 搜索记录（按网站名称或账号模糊匹配）
  Future<List<Account>> search(String keyword) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      where: 'siteName LIKE ? OR username LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );
    return maps.map((map) => Account.fromMap(map)).toList();
  }

  /// 更新一条记录
  Future<int> update(Account account) async {
    final db = await database;
    return await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  /// 删除一条记录
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 删除所有记录
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('accounts');
  }

  /// 获取记录总数
  Future<int> getCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM accounts');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
