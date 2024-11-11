// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 6;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      email: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String?,
      studentNumber: fields[3] as String,
      role: fields[4] as String,
      password: fields[5] as String,
      college: fields[6] as String?,
      fcmToken: fields[7] as String?,
      acceptingWaste: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.studentNumber)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.college)
      ..writeByte(7)
      ..write(obj.fcmToken)
      ..writeByte(8)
      ..write(obj.acceptingWaste);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
