import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/aero_theme.dart';
import '../core/providers/category_provider.dart';
import '../core/models/category_model.dart';
import '../features/finance/finance_page.dart';
import '../features/work/work_page.dart';
import '../features/fitness/fitness_page.dart';
import '../features/category/category_page.dart';
import 'custom_icons.dart';
import 'add_category_dialog.dart';

/// Aero drawer - Kategori navigasyonu + ekleme
class AeroDrawer extends StatelessWidget {
  const AeroDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // FORGE Header
          const DrawerHeader(
            child: Center(
              child: Text(
                'FORGE',
                style: TextStyle(
                  color: AeroColors.electricBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          
          // Kategori Ekle Button
          ListTile(
            leading: const Icon(
              Icons.add_circle_outline,
              color: Colors.greenAccent,
            ),
            title: const Text(
              'KATEGORİ EKLE',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onTap: () => _showAddCategoryDialog(context),
          ),
          
          const Divider(indent: 20, endIndent: 20),
          
          // Tüm kategoriler
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                final categories = categoryProvider.getAllCategories();
                
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryListItem(category: category);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddCategoryDialog(),
    );
  }
}

/// Kategori liste item'ı (korumalı kategoriler navigasyon, özel kategoriler silinebilir)
class _CategoryListItem extends StatelessWidget {
  final CategoryModel category;

  const _CategoryListItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();
    
    // Korumalı kategoriler için Dismissible yok
    if (category.isProtected) {
      return ListTile(
        leading: category.name == 'Finans'
            ? CustomIcons.dollar(
                color: AeroColors.electricBlue,
                size: 24,
              )
            : category.name == 'İş'
                ? CustomIcons.folder(
                    color: AeroColors.electricBlue,
                    size: 24,
                  )
                : category.name == 'Spor'
                    ? CustomIcons.dumbbell(
                        color: AeroColors.electricBlue,
                        size: 24,
                      )
                    : Icon(
                        IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                        color: AeroColors.electricBlue,
                      ),
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToCategory(context, category),
      );
    }
    
    // Özel kategoriler için Dismissible
    return Dismissible(
      key: Key(category.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AeroColors.obsidianCard
                : Colors.white,
            title: const Text('Kategoriyi Sil'),
            content: Text('${category.name} kategorisini silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Sil'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) {
        categoryProvider.deleteCategory(category.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${category.name} silindi')),
        );
      },
      child: ListTile(
        leading: Icon(
          IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
          color: AeroColors.electricBlue,
        ),
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToCategory(context, category),
      ),
    );
  }
  
  void _navigateToCategory(BuildContext context, CategoryModel category) {
    Navigator.pop(context); // Close drawer
    
    Widget page;
    switch (category.id) {
      case 'finance':
        page = const FinancePage();
        break;
      case 'work':
        page = const WorkPage();
        break;
      case 'fitness':
        page = const FitnessPage();
        break;
      default:
        // Custom category - to-do page
        page = CategoryPage(category: category);
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
