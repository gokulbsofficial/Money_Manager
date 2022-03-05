import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_management/screens/home/screen_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenHome(),
      routes: {
        ScreenAddtransaction.routename: (ctx) => const ScreenAddtransaction(),
      },
    );
  }
}

void showSnackBar(
    {required BuildContext context,
    String message = 'Something Wrong!!!',
    Color backgroundColor = Colors.red,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 1)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // padding: EdgeInsets.all(10),
      // behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
