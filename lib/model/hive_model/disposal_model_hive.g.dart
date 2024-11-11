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
      id: fields[0] as String,
      wasteType: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Disposal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.wasteType)
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
      other is DisposalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
