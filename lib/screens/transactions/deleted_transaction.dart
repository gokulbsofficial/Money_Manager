import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management/main.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/services/transaction/transaction_db.dart';

class DeletedTransactionList extends StatelessWidget {
  final ScrollController controller;
  final BuildContext sheetContext;
  const DeletedTransactionList({
    Key? key,
    required this.controller,
    required this.sheetContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.deletedTransactionListNotifier,
      builder:
          (BuildContext ctx, List<TransactionModel> _transactions, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            controller: controller,
            itemBuilder: (ctx, index) {
              final _transaction = _transactions[index];
              return Slidable(
                key: Key(_transaction.id!),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext ctx) {
                        final newTransaction = _transaction;
                        newTransaction.isDeleted = false;
                        TransactionDb.instance.deleteTransaction(_transaction);
                        if (_transactions.length == 1) {
                          Navigator.of(sheetContext).pop();
                        }
                        showSnackBar(
                          context: context,
                          message:
                              '${_transaction.purpose} transaction is restored',
                          backgroundColor: Colors.green,
                        );
                      },
                      icon: Icons.restore_from_trash,
                      label: 'Restore',
                      backgroundColor: Colors.blue,
                      // foregroundColor: Colors.blue,
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext ctx) {
                        TransactionDb.instance
                            .deleteHardTransaction(_transaction.id!);
                        if (_transactions.length == 1) {
                          Navigator.of(sheetContext).pop();
                        }
                        showSnackBar(
                          context: context,
                          message:
                              '${_transaction.purpose} transaction deleted permanently',
                          backgroundColor: Colors.blue,
                        );
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                      backgroundColor: Colors.red,
                      // foregroundColor: Colors.red,
                    )
                  ],
                ),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor:
                            _transaction.type == CategoryType.income
                                ? Colors.green
                                : Colors.red,
                        radius: 50,
                        child: Text(
                          parseDate(_transaction.date),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        )),
                    title: Row(
                      children: [
                        Text(
                          _transaction.purpose,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${_transaction.amount})',
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    subtitle: Text(_transaction.category.name),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(height: 10);
            },
            itemCount: _transactions.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final List<String> _splitedDate = DateFormat.MMMd().format(date).split(' ');
    return '${_splitedDate.last}\n${_splitedDate.first.toUpperCase()}';
  }
}
