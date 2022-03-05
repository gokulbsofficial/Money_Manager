import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> addTransaction(TransactionModel value);
  Future<void> updateTransaction(TransactionModel value);
  Future<void> deleteTransaction(TransactionModel value);
  Future<void> deleteHardTransaction(String id);
}

class TransactionDb implements TransactionDbFunctions {
  TransactionDb._internal();

  static TransactionDb instance = TransactionDb._internal();

  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> deletedTransactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel value) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(value.id, value);
    refresh();
  }

  @override
  Future<void> updateTransaction(TransactionModel value) async {
    addTransaction(value);
  }

  @override
  Future<void> deleteTransaction(TransactionModel value) async {
    addTransaction(value);
  }

  @override
  Future<void> deleteHardTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }

  Future<void> refresh() async {
    final _list = await getAllTransaction();
    _list.sort((first, second) => first.date.compareTo(second.date));
    transactionListNotifier.value.clear();
    deletedTransactionListNotifier.value.clear();
    Future.forEach(_list, (TransactionModel element) {
      if (element.isDeleted) {
        deletedTransactionListNotifier.value.add(element);
      } else {
        transactionListNotifier.value.add(element);
      }
    });
    transactionListNotifier.notifyListeners();
    deletedTransactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }
}
