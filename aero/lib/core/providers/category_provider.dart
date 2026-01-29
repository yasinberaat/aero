import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/storage_service.dart';

/// Provider for category management (to-do style with deadlines)
class CategoryProvider extends ChangeNotifier {
  
  /// Get all categories
  List<CategoryModel> getAllCategories() {
    return StorageService.getAllCategories();
  }
  
  /// Get protected categories (work, fitness, finance)
  List<CategoryModel> getProtectedCategories() {
    return getAllCategories().where((cat) => cat.isProtected).toList();
  }
  
  /// Get custom (non-protected) categories
  List<CategoryModel> getCustomCategories() {
    return getAllCategories().where((cat) => !cat.isProtected).toList();
  }
  
  /// Add new category
  Future<void> addCategory({
    required String name,
    required int iconCodePoint,
    DateTime? deadline,
  }) async {
    final category = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      iconCodePoint: iconCodePoint,
      isProtected: false,
      deadline: deadline,
      isCompleted: false,
    );
    
    await StorageService.addCategory(category);
    
    // Note: Notification feature temporarily disabled due to Android compatibility
    // TODO: Implement alternative notification solution
    
    notifyListeners();
  }
  
  /// Update category (toggle completion, change deadline, etc.)
  Future<void> updateCategory(CategoryModel category) async {
    await StorageService.updateCategory(category);
    notifyListeners();
  }
  
  /// Toggle category completion
  Future<void> toggleCategoryCompletion(String id) async {
    final categories = getAllCategories();
    final category = categories.firstWhere((cat) => cat.id == id);
    
    final updated = category.copyWith(isCompleted: !category.isCompleted);
    await StorageService.updateCategory(updated);
    
    notifyListeners();
  }
  
  /// Delete category (only if not protected)
  Future<void> deleteCategory(String id) async {
    await StorageService.deleteCategory(id);
    notifyListeners();
  }
}
