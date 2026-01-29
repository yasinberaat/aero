import 'package:hive/hive.dart';

part 'income_model.g.dart';

@HiveType(typeId: 1)
class IncomeModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final double amount;
  
  @HiveField(2)
  final DateTime date;
  
  @HiveField(3)
  final String? note;

  IncomeModel({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
  });
}
