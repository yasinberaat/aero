import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/aero_theme.dart';
import '../../../core/providers/finance_provider.dart';

/// Gelir ekleme dialog'u
class AddIncomeDialog extends StatefulWidget {
  const AddIncomeDialog({super.key});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AeroColors.obsidianCard
          : Colors.white,
      title: const Text('Gelir Gir'),
      content: Column(
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
    financeProvider.addIncome(
      amount: amount,
      note: _noteController.text.trim().isEmpty 
          ? null 
          : _noteController.text.trim(),
    );
    
    Navigator.pop(context);
  }
}
