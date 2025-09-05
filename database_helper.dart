import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static final Map<String, Database?> _databases = {};

  static final Map<String, String> _tables = {
    'Investment Adviser': 'assets/Investment_Adviser_as_on_Sep_04_2025.db',
    'Merchant Bankers': 'assets/Merchant_Bankers_as_on_Sep_04_2025.db',
    'Portfolio Managers': 'assets/Registered_Portfolio_Managers_as_on_Sep_04_2025.db',
    'Stock Brokers Equity Derivative': 'assets/Registered_Stock_Brokers_in_Equity_Derivative_Segment_as_on_Sep_04_2025.db',
    'Stock Brokers Equity': 'assets/Registered_Stock_Brokers_in_equity_segment_as_on_Sep_04_2025.db',
    'Research Analyst': 'assets/Research_Analyst_as_on_Sep_04_2025.db',
  };

  // --- NEW: Public getter for the list of categories ---
  static List<String> get categories => ['All', ..._tables.keys];

  static final Map<String, List<String>> _searchableColumns = {
    'Investment Adviser': [
      'Name',
      'Registration No.',
      'Contact Person',
      'Email-Id',
      'Telephone',
      'Address',
    ],
    'Merchant Bankers': [
      'Name',
      'Registration No.',
      'Contact Person',
      'Email-Id',
      'Telephone',
      'Address',
    ],
    'Portfolio Managers': [
      'Name',
      'Registration No.',
      'Contact Person',
      'Email-Id',
      'Telephone',
      'Address',
    ],
    'Stock Brokers Equity Derivative': [
      'Name',
      'Registration No.',
      'Email-Id',
      'Telephone',
      'Trade Name',
      'Address',
    ],
    'Stock Brokers Equity': [
      'Name',
      'Registration No.',
      'Email-Id',
      'Telephone',
      'Trade Name',
      'Address',
    ],
    'Research Analyst': [
      'Name',
      'Registration No.',
      'Contact Person',
      'Email-Id',
      'Telephone',
      'Address',
    ],
  };

  Future<Database> _initDatabase(String tableName) async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _tables[tableName]!.split('/').last);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(_tables[tableName]!);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    // Open the database in read-only mode to prevent write errors
    return await openDatabase(path, readOnly: true);
  }

  Future<Database> getDatabase(String tableName) async {
    if (_databases[tableName] == null || !_databases[tableName]!.isOpen) {
      _databases[tableName] = await _initDatabase(tableName);
    }
    return _databases[tableName]!;
  }

  Future<void> closeAllDatabases() async {
    for (var db in _databases.values) {
      if (db != null && db.isOpen) {
        await db.close();
      }
    }
    _databases.clear();
  }

  Future<List<Map<String, dynamic>>> search(String tableName, String searchTerm) async {
    final db = await getDatabase(tableName);
    if (searchTerm.isEmpty) {
      return [];
    }
    
    // Get the actual table name from the database, ignoring system tables
    var tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\' AND name NOT LIKE \'android_metadata\' AND name NOT LIKE \'sqlite_sequence\'');
    if (tables.isEmpty) return [];
    String actualTableName = tables.first['name'] as String;

    List<String>? columnsToSearch = _searchableColumns[tableName];
    if (columnsToSearch == null || columnsToSearch.isEmpty) {
      return [];
    }

    String whereClause = columnsToSearch.map((col) => '"$col" LIKE ? COLLATE NOCASE').join(' OR ');
    List<String> whereArgs = List.filled(columnsToSearch.length, '%${searchTerm.trim()}%');

    final List<Map<String, dynamic>> result = await db.query(
      actualTableName,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> searchAllTables(String searchTerm) async {
    List<Map<String, dynamic>> allResults = [];
    for (String tableName in _tables.keys) {
      final results = await search(tableName, searchTerm);
      for (var result in results) {
        // Create a mutable copy before adding the category
        final mutableResult = Map<String, dynamic>.from(result);
        mutableResult['category'] = tableName;
        allResults.add(mutableResult);
      }
    }
    return allResults;
  }
}