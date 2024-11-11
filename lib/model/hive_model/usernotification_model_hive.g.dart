// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usernotification_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserNotificationModelAdapter extends TypeAdapter<UserNotificationModel> {
  @override
  final int typeId = 7;

  @override
  UserNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserNotificationModel(
      studentNumber: fields[0] as String?,
      notificationIds: (fields[1] as List).cast<String>(),
      createdAt: fields[2] as DateTime?,
      updatedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserNotificationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.studentNumber)
      ..writeByte(1)
      ..write(obj.notificationIds)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
