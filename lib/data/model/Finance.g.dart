// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Finance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinanceAdapter extends TypeAdapter<Finance> {
  @override
  final int typeId = 1;

  @override
  Finance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Finance(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Finance obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.account)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.desc)
      ..writeByte(4)
      ..write(obj.trancType)
      ..writeByte(5)
      ..write(obj.trancCategory)
      ..writeByte(6)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
