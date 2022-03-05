import 'package:flutter/material.dart';
import 'package:money_management/main.dart';
import 'package:money_management/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_management/screens/category/category_add_popup.dart';
import 'package:money_management/screens/category/deleted_category_list.dart';
import 'package:money_management/screens/category/screen_category.dart';
import 'package:money_management/screens/home/widgets/bottom_navigator.dart';
import 'package:money_management/screens/transactions/deleted_transaction.dart';
import 'package:money_management/screens/transactions/screen_transaction.dart';
import 'package:money_management/services/category/category_db.dart';
import 'package:money_management/services/transaction/transaction_db.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              selectedIndexNotifier.value == 0
                  ? showDeletedTransactionBottomSheet(context)
                  : showDeletedCategoriesBottomSheet(context);
            },
            icon: const Icon(Icons.auto_delete_rounded),
            tooltip: "Trash",
          )
        ],
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigatorBar(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: const Icon(Icons.add),
        onPressed: () {
          selectedIndexNotifier.value == 0
              ? addTransaction(context)
              : addCategory(context);
        },
      ),
    );
  }

  void showDeletedCategoriesBottomSheet(BuildContext ctx) {
    final deletedListLength =
        CategoryDB.instance.deletedCategoryListListener.value.length;
    if (deletedListLength > 0) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          context: ctx,
          builder: (ctx1) {
            return DraggableScrollableSheet(
                initialChildSize: 0.6,
                // minChildSize: 0.2,
                // maxChildSize: 0.5,
                expand: false,
                builder: (ctx2, controller) {
                  return DeletedCategoryList(
                    sheetContext: ctx2,
                    controller: controller,
                  );
                });
          });
    } else {
      showSnackBar(context: ctx, message: 'Category trash is empty!!');
    }
  }

  void showDeletedTransactionBottomSheet(BuildContext ctx) {
    final deletedListLength =
        TransactionDb.instance.deletedTransactionListNotifier.value.length;
    if (deletedListLength > 0) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          context: ctx,
          builder: (ctx1) {
            return DraggableScrollableSheet(
                initialChildSize: 0.6,
                // minChildSize: 0.2,
                // maxChildSize: 0.5,
                expand: false,
                builder: (ctx2, controller) {
                  return DeletedTransactionList(
                    sheetContext: ctx2,
                    controller: controller,
                  );
                });
          });
    } else {
      showSnackBar(context: ctx, message: 'Transaction trash is empty!!');
    }
  }

  void addCategory(BuildContext ctx) {
    showCategoryAddPopup(ctx);
  }

  void addTransaction(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(ScreenAddtransaction.routename);
  }
}
