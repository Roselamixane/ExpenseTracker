// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserdataAdapter extends TypeAdapter<Userdata> {
  @override
  final int typeId = 3;

  @override
  Userdata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Userdata(
      fields[0] as String,
      fields[2] as double,
      fields[3] as bool,
      fields[4] as bool,
      fields[1] as String,
      fields[5] as bool,
      profileImagePath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Userdata obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.deviceAuth)
      ..writeByte(4)
      ..write(obj.notifications)
      ..writeByte(5)
      ..write(obj.defaultTheme)
      ..writeByte(6)
      ..write(obj.profileImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserdataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
