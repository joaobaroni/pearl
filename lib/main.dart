import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/dtos/address_hive_dto.dart';
import 'data/dtos/asset_hive_dto.dart';
import 'data/dtos/home_hive_dto.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HomeHiveDtoAdapter());
  Hive.registerAdapter(AddressHiveDtoAdapter());
  Hive.registerAdapter(AssetHiveDtoAdapter());

  await setupServiceLocator();
  runApp(const PearlApp());
}

class PearlApp extends StatelessWidget {
  const PearlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pearl',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
