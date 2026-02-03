import 'package:flutter/widgets.dart';

import 'asset_category.dart';

class AssetTemplate {
  final String name;
  final AssetCategory category;
  final IconData icon;

  const AssetTemplate({
    required this.name,
    required this.category,
    required this.icon,
  });
}
