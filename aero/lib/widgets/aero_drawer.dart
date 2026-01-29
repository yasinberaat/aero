import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/aero_theme.dart';
import '../core/providers/category_provider.dart';
import '../core/models/category_model.dart';
import '../features/finance/finance_page.dart';
import '../features/work/work_page.dart';
import '../features/fitness/fitness_page.dart';
import 'custom_icons.dart';

/// Aero drawer - Sadece korumalı kategorilere navigasyon
class AeroDrawer extends StatelessWidget {
  const AeroDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // AERO Header
          const DrawerHeader(
            child: Center(
              child: Text(
                'AERO',
                style: TextStyle(
                  color: AeroColors.electricBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          
          // Korumalı kategoriler (Finance, Work, Fitness)
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                final protectedCategories = categoryProvider.getProtectedCategories();
                
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: protectedCategories.length,
                  itemBuilder: (context, index) {
                    final category = protectedCategories[index];
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
}

/// Kategori liste item'ı (sadece navigasyon)
class _CategoryListItem extends StatelessWidget {
  final CategoryModel category;

  const _CategoryListItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: category.name == 'Finans'
          ? CustomIcons.dollar(
              color: AeroColors.electricBlue,
              size: 24,
            )
          : category.name == 'İş / Emlak'
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
        // Custom category - show placeholder for now
        page = Scaffold(
          appBar: AppBar(title: Text(category.name.toUpperCase())),
          body: Center(
            child: Text(
              '${category.name} sayfası yakında...',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
