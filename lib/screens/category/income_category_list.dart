import 'package:flutter/material.dart';
import 'package:money_management/main.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/services/category/category_db.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB.instance.incomeCategoryListListener,
        builder: (
          BuildContext ctx1,
          List<CategoryModel> categories,
          Widget? _,
        ) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final _category = categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      key: Key(_category.id),
                      title: Text(_category.name),
                      trailing: IconButton(
                          onPressed: () {
                            final _newCategory = _category;
                            _category.isDeleted = true;
                            CategoryDB.instance
                                .deleteOrUndeleteCategory(_newCategory);
                            showSnackBar(
                              context: context,
                              message: '${_category.name} category deleted',
                              backgroundColor: Colors.red,
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          tooltip: 'Delete Income Category'),
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
