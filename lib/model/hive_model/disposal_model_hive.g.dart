// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disposal_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DisposalAdapter extends TypeAdapter<Disposal> {
  @override
  final int typeId = 1;

  @override
  Disposal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Disposal(
      wasteType: fields[0] as String,
      createdAt: fields[1] as DateTime,
      updatedAt: fields[2] as DateTime,
      dayOfWeek: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Disposal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.wasteType)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.dayOfWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisposalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
