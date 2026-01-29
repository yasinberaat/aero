import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/aero_theme.dart';
import '../../../core/providers/finance_provider.dart';
import '../../../core/constants/expense_categories.dart';

/// Harcama ekleme dialog'u
class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = ExpenseCategories.shopping;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AeroColors.obsidianCard,
      title: const Text('Harcama Gir'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Miktar
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Miktar (₺)',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            
            const SizedBox(height: 16),
            
            // Kategori seçimi
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: ExpenseCategories.all.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        ExpenseCategories.getIcon(category),
                        size: 20,
                        color: ExpenseCategories.getColor(category),
                      ),
                      const SizedBox(width: 12),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Not (opsiyonel)
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Not (opsiyonel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
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
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;
    
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;
    
    final financeProvider = context.read<FinanceProvider>();
    financeProvider.addExpense(
      amount: amount,
      category: _selectedCategory,
      note: _noteController.text.trim().isEmpty 
          ? null 
          : _noteController.text.trim(),
    );
    
    Navigator.pop(context);
  }
}
