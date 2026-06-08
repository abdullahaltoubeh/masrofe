import 'package:hive_flutter/hive_flutter.dart';
import 'package:masrofe/models/transaction_model.dart';

class TransactionRepository {
  static const String _boxName = 'transactions';

  Future<Box<TransactionModel>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<TransactionModel>(_boxName);
    }
    return await Hive.openBox<TransactionModel>(_boxName);
  }

  Future<List<TransactionModel>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> add(TransactionModel transaction) async {
    final box = await _openBox();
    await box.put(transaction.id, transaction);
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
