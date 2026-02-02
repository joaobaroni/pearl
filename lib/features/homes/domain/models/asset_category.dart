import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum AssetCategory {
  hvac('HVAC', LucideIcons.wind),
  solar('Solar', LucideIcons.zap),
  appliances('Appliance', LucideIcons.refrigerator),
  electrical('Electrical', LucideIcons.cpu),
  plumbing('Plumbing', LucideIcons.wrench);

  final String label;
  final IconData icon;
  const AssetCategory(this.label, this.icon);
}
