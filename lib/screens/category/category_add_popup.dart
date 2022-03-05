import 'package:flutter/material.dart';
import 'package:money_management/main.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/services/category/category_db.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final TextEditingController _nameController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Category Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expence', type: CategoryType.expence),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  final _name = _nameController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategoryNotifier.value;
                  final _category = CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _name,
                    type: _type,
                  );
                  CategoryDB().insertCategory(_category);
                  Navigator.of(ctx).pop();
                  showSnackBar(
                    context: context,
                    message: '$_name category added',
                    backgroundColor: Colors.green,
                  );
                },
                child: const Text('Add')),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (context, CategoryType newValue, child) {
              return Radio<CategoryType>(
                value: type,
                groupValue: newValue,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                },
              );
            }),
        Text(title)
      ],
    );
  }
}
