import 'package:spend_wise/models/budget.dart';
import 'package:spend_wise/models/transction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('spendWise.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Define the data types
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    // Create budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id $idType,
        category $textType,
        amount $doubleType,
        start_date $textType,
        end_date $textType
      )
    ''');

    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        category $textType,
        method $textType,
        date $textType,
        time $textType,
        amount $doubleType
      )
    ''');
  }

  // BUDGET CRUD OPERATIONS

  Future<int> createBudget(Budget budget) async {
    final db = await instance.database;
    return await db.insert('budgets', budget.toJson());
  }

  Future<Budget> readBudget(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'budgets',
      columns: ['id', 'category', 'amount', 'start_date', 'end_date'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Budget.fromJson(maps.first);
    } else {
      throw Exception('Budget with ID $id not found');
    }
  }

  Future<List<Budget>> readAllBudgets() async {
    final db = await instance.database;
    final result = await db.query('budgets');
    return result.map((json) => Budget.fromJson(json)).toList();
  }

  Future<List<Budget>> readBudgetsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'budgets',
      where: 'category = ?',
      whereArgs: [category],
    );
    return result.map((json) => Budget.fromJson(json)).toList();
  }

  Future<int> updateBudget(Budget budget) async {
    final db = await instance.database;
    return await db.update(
      'budgets',
      budget.toJson(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> deleteBudget(int id) async {
    final db = await instance.database;
    return await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TRANSACTION CRUD OPERATIONS
  
  Future<int> createTransaction(Transction transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toJson());
  }

  Future<Transction> readTransaction(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'transactions',
      columns: ['id', 'category', 'method', 'date', 'time', 'amount'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Transction.fromJson(maps.first);
    } else {
      throw Exception('Transaction with ID $id not found');
    }
  }

  Future<List<Transction>> readAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions');
    return result.map((json) => Transction.fromJson(json)).toList();
  }

  Future<List<Transction>> readTransactionsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category],
    );
    return result.map((json) => Transction.fromJson(json)).toList();
  }

  Future<List<Transction>> readTransactionsByDateRange(String startDate, String endDate) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
    );
    return result.map((json) => Transction.fromJson(json)).toList();
  }

  Future<int> updateTransaction(int id, Transction transaction) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      transaction.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ANALYTICS METHODS

  Future<double> getTotalSpentByCategory(String category) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE category = ?',
      [category],
    );
    return result.first['total'] == null ? 0.0 : result.first['total'] as double;
  }

  Future<double> getTotalSpentByDateRange(String startDate, String endDate) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE date >= ? AND date <= ?',
      [startDate, endDate],
    );
    return result.first['total'] == null ? 0.0 : result.first['total'] as double;
  }

  Future<Map<String, double>> getCategorySpending() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM transactions GROUP BY category',
    );
    
    Map<String, double> categorySpending = {};
    for (var row in result) {
      categorySpending[row['category'] as String] = row['total'] as double;
    }
    return categorySpending;
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}