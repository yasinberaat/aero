import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../models/income_model.dart';
import '../services/storage_service.dart';

/// Provider for finance data (expenses and income)
class FinanceProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  
  DateTime get selectedDate => _selectedDate;
  
  /// Change selected date and notify listeners
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
  
  /// Get today's expenses
  List<ExpenseModel> getTodayExpenses() {
    return StorageService.getExpensesByDate(_selectedDate);
  }
  
  /// Get today's income
  List<IncomeModel> getTodayIncome() {
    return StorageService.getIncomesByDate(_selectedDate);
  }
  
  /// Calculate total expenses for today
  double getTotalExpenses() {
    final expenses = getTodayExpenses();
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
  
  /// Calculate total income for today
  double getTotalIncome() {
    final incomes = getTodayIncome();
    return incomes.fold(0.0, (sum, income) => sum + income.amount);
  }
  
  /// Get expenses grouped by category for today
  Map<String, double> getExpensesByCategory() {
    final expenses = getTodayExpenses();
    final Map<String, double> categoryTotals = {};
    
    for (var expense in expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    
    return categoryTotals;
  }
  
  /// Add new expense
  Future<void> addExpense({
    required double amount,
    required String category,
    String? note,
    DateTime? date,
  }) async {
    final expense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
      note: note,
    );
    
    await StorageService.addExpense(expense);
    notifyListeners();
  }
  
  /// Add new income
  Future<void> addIncome({
    required double amount,
    String? note,
  }) async {
    final income = IncomeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      date: _selectedDate,
      note: note,
    );
    
    await StorageService.addIncome(income);
    notifyListeners();
  }
  
  /// Delete expense
  Future<void> deleteExpense(String id) async {
    await StorageService.deleteExpense(id);
    notifyListeners();
  }
  
  /// Delete income
  Future<void> deleteIncome(String id) async {
    await StorageService.deleteIncome(id);
    notifyListeners();
  }
  
  /// Günlük kar/zarar hesapla (gelir - gider)
  double getDailyProfit() {
    return getTotalIncome() - getTotalExpenses();
  }
  
  /// Haftalık kar/zarar hesapla (son 7 gün)
  double getWeeklyProfit() {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    
    double totalIncome = 0;
    double totalExpenses = 0;
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dayIncomes = StorageService.getIncomesByDate(date);
      final dayExpenses = StorageService.getExpensesByDate(date);
      
      totalIncome += dayIncomes.fold(0.0, (sum, income) => sum + income.amount);
      totalExpenses += dayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    }
    
    return totalIncome - totalExpenses;
  }
  
  /// Belirli bir tarih için kar/zarar hesapla
  double getProfitForDate(DateTime date) {
    final dayIncomes = StorageService.getIncomesByDate(date);
    final dayExpenses = StorageService.getExpensesByDate(date);
    
    final income = dayIncomes.fold(0.0, (sum, inc) => sum + inc.amount);
    final expenses = dayExpenses.fold(0.0, (sum, exp) => sum + exp.amount);
    
    return income - expenses;
  }
}
