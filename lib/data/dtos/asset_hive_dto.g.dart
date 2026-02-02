// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetHiveDtoAdapter extends TypeAdapter<AssetHiveDto> {
  @override
  final int typeId = 2;

  @override
  AssetHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssetHiveDto(
      id: fields[0] as String,
      name: fields[1] as String,
      categoryIndex: fields[2] as int,
      manufacturer: fields[3] as String,
      model: fields[4] as String,
      installDate: fields[5] as DateTime?,
      warrantyDate: fields[6] as DateTime?,
      notes: fields[7] as String,
      homeId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AssetHiveDto obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryIndex)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.model)
      ..writeByte(5)
      ..write(obj.installDate)
      ..writeByte(6)
      ..write(obj.warrantyDate)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.homeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
