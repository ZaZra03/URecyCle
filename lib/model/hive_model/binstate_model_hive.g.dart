// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binstate_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BinStateModelAdapter extends TypeAdapter<BinStateModel> {
  @override
  final int typeId = 0;

  @override
  BinStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BinStateModel(
      acceptingWaste: fields[0] as bool,
      createdAt: fields[1] as DateTime?,
      updatedAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BinStateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.acceptingWaste)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
