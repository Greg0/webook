import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:webook/main.dart';

part 'device.g.dart';

@HiveType(typeId: 1)
enum EbookFormat {
  @HiveField(0)
  EPUB,
  @HiveField(1)
  MOBI
}

const ebookFormats = <EbookFormat, String>{
  EbookFormat.EPUB: "EPUB",
  EbookFormat.MOBI: "MOBI",
};

@HiveType(typeId: 0)
class Device {
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  EbookFormat format;
  @HiveField(3)
  bool isDefault;

  Device(this.name, this.email, this.format, this.isDefault);

  String get ebookFormat {
    return ebookFormats[format] ?? "MOBI - Kindle readers";
  }
}

class DeviceRepository {
  static List<DropdownMenuItem<Device>> getDevices() {
    Box<Device> box = Hive.box<Device>(devicesBox);
    List<Device> devices = box.values.toList().cast<Device>();
    List<DropdownMenuItem<Device>> menuItems = [];
    for (var device in devices) {
      menuItems.add(DropdownMenuItem(
          child: Text(device.name.toString()), value: device));
    }
    return menuItems;
  }
}
