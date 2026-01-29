import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 3)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String day;

  @HiveField(2)
  final String exerciseName;

  @HiveField(3)
  final int sets;

  @HiveField(4)
  final int reps;

  @HiveField(5)
  final List<String> comments;

  WorkoutModel({
    required this.id,
    required this.day,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    List<String>? comments,
  }) : comments = comments ?? [];
}
