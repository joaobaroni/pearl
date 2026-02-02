import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/shell/pearl_app_bar.dart';
import '../../../../core/theme/app_colors.dart';

class HomeDetailPage extends StatelessWidget {
  const HomeDetailPage({
    super.key,
    required this.homeId,
  });

  final String homeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PearlAppBar(
        title: homeId,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.body),
          onPressed: () => context.pop(),
        ),
        actionLabel: 'Add Asset',
        onActionPressed: () {},
      ),
      body: Center(
        child: Text('Home Detail: $homeId'),
      ),
    );
  }
}
