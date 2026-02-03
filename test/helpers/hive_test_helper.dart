import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pearl/data/dtos/address_hive_dto.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/dtos/home_hive_dto.dart';

Future<Directory> initHiveForTest() async {
  final dir = await Directory.systemTemp.createTemp('pearl_test_');
  Hive.init(dir.path);

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(HomeHiveDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AddressHiveDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(AssetHiveDtoAdapter());
  }

  return dir;
}

Future<void> tearDownHive(Directory dir) async {
  await Hive.close();
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}
