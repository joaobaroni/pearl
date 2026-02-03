import 'package:dartz/dartz.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/fuzzy_match.dart';
import '../../domain/models/asset_category.dart';
import '../../domain/models/asset_template.dart';
import '../../domain/repositories/asset_template_repository.dart';

class AssetTemplateRepositoryImpl implements AssetTemplateRepository {
  static const _templates = [
    // HVAC
    AssetTemplate(
      name: 'Air Conditioner',
      category: AssetCategory.hvac,
      icon: LucideIcons.wind,
    ),
    AssetTemplate(
      name: 'Central Heater',
      category: AssetCategory.hvac,
      icon: LucideIcons.flame,
    ),
    AssetTemplate(
      name: 'Heat Pump',
      category: AssetCategory.hvac,
      icon: LucideIcons.thermometer,
    ),
    AssetTemplate(
      name: 'Smart Thermostat',
      category: AssetCategory.hvac,
      icon: LucideIcons.gauge,
    ),

    // Solar
    AssetTemplate(
      name: 'Solar Panel Array',
      category: AssetCategory.solar,
      icon: LucideIcons.sun,
    ),
    AssetTemplate(
      name: 'Solar Inverter',
      category: AssetCategory.solar,
      icon: LucideIcons.zap,
    ),
    AssetTemplate(
      name: 'Storage Battery',
      category: AssetCategory.solar,
      icon: LucideIcons.battery,
    ),

    // Appliances
    AssetTemplate(
      name: 'Refrigerator/Freezer',
      category: AssetCategory.appliances,
      icon: LucideIcons.refrigerator,
    ),
    AssetTemplate(
      name: 'Dishwasher',
      category: AssetCategory.appliances,
      icon: LucideIcons.sparkles,
    ),
    AssetTemplate(
      name: 'Stove/Oven',
      category: AssetCategory.appliances,
      icon: LucideIcons.flame,
    ),

    // Electrical
    AssetTemplate(
      name: 'Electrical Panel',
      category: AssetCategory.electrical,
      icon: LucideIcons.cpu,
    ),
    AssetTemplate(
      name: 'Generator',
      category: AssetCategory.electrical,
      icon: LucideIcons.zap,
    ),
    AssetTemplate(
      name: 'Smart Lighting',
      category: AssetCategory.electrical,
      icon: LucideIcons.lightbulb,
    ),

    // Plumbing
    AssetTemplate(
      name: 'Water Heater',
      category: AssetCategory.plumbing,
      icon: LucideIcons.droplets,
    ),
    AssetTemplate(
      name: 'Water Pump',
      category: AssetCategory.plumbing,
      icon: LucideIcons.wrench,
    ),
    AssetTemplate(
      name: 'Irrigation System',
      category: AssetCategory.plumbing,
      icon: LucideIcons.sprout,
    ),
  ];

  @override
  Future<Either<Failure, List<AssetTemplate>>> search(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final results = _templates
          .where(
            (item) =>
                fuzzyMatch(query, item.name) ||
                fuzzyMatch(query, item.category.label),
          )
          .toList();

      return Right(results);
    } catch (e) {
      return Left(StorageFailure('Failed to search templates: $e'));
    }
  }
}
