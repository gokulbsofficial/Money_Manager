import 'package:flutter/material.dart';
import 'package:money_management/main.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/services/category/category_db.dart';

class DeletedCategoryList extends StatelessWidget {
  final ScrollController controller;
  final BuildContext sheetContext;
  const DeletedCategoryList({
    Key? key,
    required this.controller,
    required this.sheetContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB.instance.deletedCategoryListListener,
        builder: (
          BuildContext ctx1,
          List<CategoryModel> categories,
          Widget? _,
        ) {
          return ListView.separated(
              controller: controller,
              itemBuilder: (ctx, index) {
                final _category = categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      key: Key(_category.id),
                      title: Text(_category.name),
                      subtitle: Text(
                        _category.type == CategoryType.income
                            ? 'Type: Income'
                            : 'Type: Expence',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          final _newCategory = _category;
                          _newCategory.isDeleted = false;
                          CategoryDB.instance
                              .deleteOrUndeleteCategory(_newCategory);
                          if (categories.length == 1) {
                            Navigator.of(sheetContext).pop();
                          }
                          showSnackBar(
                            context: context,
                            message: '${_category.name} category restored',
                            backgroundColor: Colors.green,
                          );
                        },
                        icon: const Icon(
                          Icons.restore_from_trash,
                          color: Colors.blue,
                        ),
                        tooltip: 'Delete Expence Category',
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 10);
              },
              itemCount: categories.length);
        });
  }
}
