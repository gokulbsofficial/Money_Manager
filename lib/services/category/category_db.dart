import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/category/category_model.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> updateCategory(CategoryModel value);
  Future<void> deleteOrUndeleteCategory(CategoryModel value);
  Future<void> permanentDeleteCategory(String id);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenceCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> deletedCategoryListListener =
      ValueNotifier([]);

  @override
  Future<void> insertOrUpdateOrDeleteCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    insertOrUpdateOrDeleteCategory(value);
  }

  @override
  Future<void> updateCategory(CategoryModel value) async {
    insertOrUpdateOrDeleteCategory(value);
  }

  @override
  Future<void> deleteOrUndeleteCategory(CategoryModel value) async {
    insertOrUpdateOrDeleteCategory(value);
  }

  @override
  Future<void> permanentDeleteCategory(String id) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(id);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenceCategoryListListener.value.clear();
    deletedCategoryListListener.value.clear();
    await Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income && !category.isDeleted) {
        incomeCategoryListListener.value.add(category);
      } else if (category.type == CategoryType.expence && !category.isDeleted) {
        expenceCategoryListListener.value.add(category);
      } else {
        deletedCategoryListListener.value.add(category);
      }
    });
    incomeCategoryListListener.notifyListeners();
    expenceCategoryListListener.notifyListeners();
    deletedCategoryListListener.notifyListeners();
  }
}
