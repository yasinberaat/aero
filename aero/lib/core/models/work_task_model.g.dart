// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkTaskModelAdapter extends TypeAdapter<WorkTaskModel> {
  @override
  final int typeId = 6;

  @override
  WorkTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkTaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as TaskType,
      priority: fields[3] as TaskPriority?,
      day: fields[4] as String?,
      deadline: fields[5] as DateTime,
      isCompleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkTaskModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.day)
      ..writeByte(5)
      ..write(obj.deadline)
      ..writeByte(6)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskTypeAdapter extends TypeAdapter<TaskType> {
  @override
  final int typeId = 4;

  @override
  TaskType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskType.daily;
      case 1:
        return TaskType.weekly;
      case 2:
        return TaskType.monthly;
      default:
        return TaskType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, TaskType obj) {
    switch (obj) {
      case TaskType.daily:
        writer.writeByte(0);
        break;
      case TaskType.weekly:
        writer.writeByte(1);
        break;
      case TaskType.monthly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 5;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.veryImportant;
      case 1:
        return TaskPriority.important;
      case 2:
        return TaskPriority.moderate;
      case 3:
        return TaskPriority.unimportant;
      default:
        return TaskPriority.veryImportant;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.veryImportant:
        writer.writeByte(0);
        break;
      case TaskPriority.important:
        writer.writeByte(1);
        break;
      case TaskPriority.moderate:
        writer.writeByte(2);
        break;
      case TaskPriority.unimportant:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
