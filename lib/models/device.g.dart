// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 0;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      fields[0] as String,
      fields[1] as String,
      fields[2] as EbookFormat,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.format)
      ..writeByte(3)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EbookFormatAdapter extends TypeAdapter<EbookFormat> {
  @override
  final int typeId = 1;

  @override
  EbookFormat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EbookFormat.EPUB;
      case 1:
        return EbookFormat.MOBI;
      default:
        return EbookFormat.EPUB;
    }
  }

  @override
  void write(BinaryWriter writer, EbookFormat obj) {
    switch (obj) {
      case EbookFormat.EPUB:
        writer.writeByte(0);
        break;
      case EbookFormat.MOBI:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EbookFormatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
