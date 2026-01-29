import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/aero_theme.dart';
import '../core/providers/category_provider.dart';

/// Kategori ekleme dialog'u (deadline'lı to-do tarzı)
class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AeroColors.obsidianCard,
      title: const Text('Yeni Kategori Ekle'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Kategori Adı',
          border: OutlineInputBorder(),
          hintText: 'Örn: Proje X, Alışveriş Listesi',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Ekle'),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    
    final categoryProvider = context.read<CategoryProvider>();
    final navigator = Navigator.of(context);
    
    categoryProvider.addCategory(
      name: name,
      iconCodePoint: Icons.check_circle_outline.codePoint,
      deadline: null, // Deadline kategori sayfasında görevlere eklenecek
    );
    
    navigator.pop();
  }
}
