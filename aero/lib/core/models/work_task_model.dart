import 'package:hive/hive.dart';

part 'work_task_model.g.dart';

@HiveType(typeId: 4)
enum TaskType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
}

@HiveType(typeId: 5)
enum TaskPriority {
  @HiveField(0)
  veryImportant,
  @HiveField(1)
  important,
  @HiveField(2)
  moderate,
  @HiveField(3)
  unimportant,
}

@HiveType(typeId: 6)
class WorkTaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final TaskType type;

  @HiveField(3)
  final TaskPriority? priority;

  @HiveField(4)
  final String? day;

  @HiveField(5)
  final DateTime deadline;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  final List<int>? repeatDays; // Haftanın günleri: 1=Pzt, 2=Sal, ..., 7=Paz

  @HiveField(8)
  final bool repeatForever; // Sürekli tekrarla

  WorkTaskModel({
    required this.id,
    required this.title,
    required this.type,
    this.priority,
    this.day,
    required this.deadline,
    this.isCompleted = false,
    this.repeatDays,
    this.repeatForever = false,
  });
}
