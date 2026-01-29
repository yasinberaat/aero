import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int iconCodePoint;
  
  @HiveField(3)
  final bool isProtected; // work, fitness, finance korumalı
  
  @HiveField(4)
  final DateTime? deadline; // To-do için deadline
  
  @HiveField(5)
  final bool isCompleted;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.isProtected = false,
    this.deadline,
    this.isCompleted = false,
  });
  
  CategoryModel copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    bool? isProtected,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isProtected: isProtected ?? this.isProtected,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
