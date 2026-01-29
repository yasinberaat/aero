import 'package:flutter/material.dart';
import '../theme/aero_theme.dart';

class ExpenseCategories {
  static const String shopping = 'Alışveriş';
  static const String market = 'Market';
  static const String transport = 'Ulaşım';
  static const String food = 'Yiyecek';
  static const String bills = 'Faturalar';
  static const String other = 'Diğer';
  
  static const List<String> all = [
    shopping,
    market,
    transport,
    food,
    bills,
    other,
  ];
  
  static Color getColor(String category) {
    switch (category) {
      case shopping:
        return AeroColors.expenseShopping;
      case market:
        return AeroColors.expenseMarket;
      case transport:
        return AeroColors.expenseTransport;
      case food:
        return AeroColors.expenseFood;
      case bills:
        return AeroColors.expenseBills;
      case other:
        return AeroColors.expenseOther;
      default:
        return AeroColors.expenseOther;
    }
  }
  
  static IconData getIcon(String category) {
    switch (category) {
      case shopping:
        return Icons.shopping_bag;
      case market:
        return Icons.shopping_cart;
      case transport:
        return Icons.directions_car;
      case food:
        return Icons.restaurant;
      case bills:
        return Icons.receipt_long;
      case other:
        return Icons.more_horiz;
      default:
        return Icons.more_horiz;
    }
  }
}
