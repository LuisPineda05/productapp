import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:productapp/data/models/product.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper2 {
  final int version = 2;
  final String databaseName = 'prod.db';
  final String tableName = 'products';

  Database? db;

  Future<Database> openDb() async {
    db ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (database, version) async {
        //await deleteTable();
        database.execute("""CREATE TABLE products(
      id INTEGER PRIMARY KEY NOT NULL,
      title TEXT,
      description TEXT,
      price INTEGER,
      stock INTEGER,
      thumbnail TEXT,
      is_in INTEGER
    )""");
      },
      version: version,
    );
    return db as Database;
  }

  Future<void> deleteDatabase(String path) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'prod.db');
    await deleteDatabase(path);
  }

  Future<void> deleteTable() async {
    final db = await openDb();
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  insert(Product product) async {
    await db?.insert(tableName, product.toMap());
  }

  delete(Product product) async {
    await db?.delete(tableName, where: 'id=?', whereArgs: [product.id]);
  }

  Future<bool> isIn(Product product) async {
    final maps =
        await db?.query(tableName, where: 'id=?', whereArgs: [product.id]);
    return maps!.isNotEmpty;
  }

  Future<List<Product>> fetchAll() async {
    final maps = await db?.query(tableName);
    List<Product> products = maps!.map((map) => Product.fromMap(map)).toList();
    return products;
  }

  Future<int> getTotalStock() async {
    final db = await openDb();
    final result = await db.rawQuery('SELECT SUM(stock) FROM $tableName');
    return (result.first.values.first as int?) ?? 0;
  }

  Future<int> getTotalPrice() async {
    final db = await openDb();
    final result = await db.rawQuery('SELECT SUM(price) FROM $tableName');
    return (result.first.values.first as int?) ?? 0;
  }

  Future<int> getProductCount() async {
    final db = await openDb();
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return (result.first.values.first as int?) ?? 0;
  }
}
