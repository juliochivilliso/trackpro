// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 0;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      id: fields[0] as String,
      name: fields[1] as String,
      plate: fields[2] as String,
      type: fields[3] as String,
      online: fields[4] as bool,
      lat: fields[5] as double,
      lng: fields[6] as double,
      speed: fields[7] as double,
      heading: fields[8] as double,
      battery: fields[9] as int,
      signal: fields[10] as int,
      accOn: fields[11] as bool,
      engineCut: fields[12] as bool,
      color: fields[13] as String,
      imei: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.plate)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.online)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lng)
      ..writeByte(7)
      ..write(obj.speed)
      ..writeByte(8)
      ..write(obj.heading)
      ..writeByte(9)
      ..write(obj.battery)
      ..writeByte(10)
      ..write(obj.signal)
      ..writeByte(11)
      ..write(obj.accOn)
      ..writeByte(12)
      ..write(obj.engineCut)
      ..writeByte(13)
      ..write(obj.color)
      ..writeByte(14)
      ..write(obj.imei);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
