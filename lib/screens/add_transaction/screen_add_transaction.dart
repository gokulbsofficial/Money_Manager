import 'package:flutter/material.dart';
import 'package:money_management/main.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/services/category/category_db.dart';
import 'package:money_management/services/transaction/transaction_db.dart';

class ScreenAddtransaction extends StatefulWidget {
  const ScreenAddtransaction({Key? key}) : super(key: key);
  static const routename = 'add-tranaction';

  @override
  State<ScreenAddtransaction> createState() => _ScreenAddtransactionState();
}

class _ScreenAddtransactionState extends State<ScreenAddtransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Purpose
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                ),
              ),
              // Amount
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
              ),
              // Date
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate:
                        _selectedDate == null ? DateTime.now() : _selectedDate!,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate!.toString().split(' ')[0],
                ),
              ),
              // Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio<CategoryType>(
                        key: const Key('Income'),
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          if (newValue == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategoryType = newValue;
                            _categoryId = null;
                            _selectedCategoryModel = null;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<CategoryType>(
                        key: const Key('Expence'),
                        value: CategoryType.expence,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          if (newValue == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategoryType = newValue;
                            _categoryId = null;
                            _selectedCategoryModel = null;
                          });
                        },
                      ),
                      const Text('Expence'),
                    ],
                  ),
                ],
              ),
              // Category Type
              DropdownButton<String>(
                hint: const Text('Select Category Type'),
                value: _categoryId,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB.instance.incomeCategoryListListener
                        : CategoryDB.instance.expenceCategoryListListener)
                    .value
                    .map(
                  (e) {
                    return DropdownMenuItem(
                      key: Key(e.id),
                      value: e.id,
                      child: Text(e.name),
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _categoryId = value;
                  });
                },
              ),
              // Submit
              ElevatedButton(
                onPressed: () => addTransaction(context),
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction(BuildContext ctx) async {
    final _purpose = _purposeTextEditingController.text;
    final _amount = _amountTextEditingController.text;
    final _parsedAmount = double.tryParse(_amount);
    if (_purpose.isEmpty ||
        _amount.isEmpty ||
        _parsedAmount == null ||
        _selectedCategoryModel == null ||
        _selectedDate == null) {
      showSnackBar(
        context: ctx,
        message: _purpose.isEmpty
            ? 'Purpose is empty'
            : (_amount.isEmpty || _parsedAmount == null)
                ? 'Amount is  empty'
                : _selectedCategoryModel == null
                    ? 'Category Type isEmpty'
                    : _selectedDate == null
                        ? 'Select a Date'
                        : 'Field missing',
        backgroundColor: Colors.green,
      );
      return;
    }

    final _transaction = TransactionModel(
      purpose: _purpose,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    await TransactionDb.instance.addTransaction(_transaction);
    Navigator.of(ctx).pop();
    showSnackBar(
      context: ctx,
      message: '${_transaction.purpose} transaction added',
      backgroundColor: Colors.green,
    );
  }
}
