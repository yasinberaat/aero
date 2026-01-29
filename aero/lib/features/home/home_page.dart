import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/aero_theme.dart';
import '../../core/providers/category_provider.dart';
import '../finance/finance_page.dart';
import '../work/work_page.dart';
import '../fitness/fitness_page.dart';
import '../../widgets/aero_drawer.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/custom_icons.dart';

/// Ana sayfa - 3 kalıcı kategori kartı (work, fitness, finance)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AERO'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      drawer: const AeroDrawer(),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final protectedCategories = categoryProvider.getProtectedCategories();
          
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KATEGORİLER',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: protectedCategories.length,
                    itemBuilder: (context, index) {
                      final category = protectedCategories[index];
                      return GestureDetector(
                        onTap: () {
                          if (category.name == 'Finans') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FinancePage()),
                            );
                          } else if (category.name == 'İş / Emlak') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const WorkPage()),
                            );
                          } else if (category.name == 'Spor') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FitnessPage()),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AeroColors.obsidianCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AeroColors.cardBorder),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Custom icon based on category
                              if (category.name == 'Finans')
                                CustomIcons.dollar(
                                  color: AeroColors.electricBlue,
                                  size: 48,
                                )
                              else if (category.name == 'İş / Emlak')
                                CustomIcons.folder(
                                  color: AeroColors.electricBlue,
                                  size: 48,
                                )
                              else if (category.name == 'Spor')
                                CustomIcons.dumbbell(
                                  color: AeroColors.electricBlue,
                                  size: 48,
                                )
                              else
                                Icon(
                                  IconData(
                                    category.iconCodePoint,
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  size: 48,
                                  color: AeroColors.electricBlue,
                                ),
                              const SizedBox(height: 12),
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

