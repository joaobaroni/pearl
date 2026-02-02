// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressHiveDtoAdapter extends TypeAdapter<AddressHiveDto> {
  @override
  final int typeId = 1;

  @override
  AddressHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressHiveDto(
      street: fields[0] as String,
      city: fields[1] as String,
      state: fields[2] as String,
      zip: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddressHiveDto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.street)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.zip);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
