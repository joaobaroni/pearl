// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeHiveDtoAdapter extends TypeAdapter<HomeHiveDto> {
  @override
  final int typeId = 0;

  @override
  HomeHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeHiveDto(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as AddressHiveDto,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HomeHiveDto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
