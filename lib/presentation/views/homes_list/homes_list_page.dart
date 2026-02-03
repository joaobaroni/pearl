import 'package:flutter/material.dart';

import '../../../core/controllers/controller.dart';
import '../../../core/responsive/responsive.dart';
import '../../widgets/pearl_app_bar.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/models/home_model.dart';
import 'homes_list_controller.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../widgets/add_placeholder_card.dart';
import '../../widgets/empty_homes_view.dart';
import '../../widgets/home_card.dart';

class HomesListPage extends StatefulWidget {
  const HomesListPage({super.key});

  @override
  State<HomesListPage> createState() => _HomesListPageState();
}

class _HomesListPageState extends State<HomesListPage>
    with ViewMixin<HomesListPage, HomesListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PearlAppBar(
        title: 'Meus Lares',
        actionLabel: 'Add Home',
        onActionPressed: () => controller.openHomeForm(context),
      ),
      body: SafeArea(
        child: SelectionArea(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.homes.isEmpty) {
                return _HomesEmptyState(
                  onAddHome: () => controller.openHomeForm(context),
                );
              }
              return _HomesGrid(
                homes: controller.homes,
                onAddHome: () => controller.openHomeForm(context),
                onOpenHome: (home) =>
                    controller.onDetailsTap(context: context, id: home.id),
                onEditHome: (home) =>
                    controller.openHomeForm(context, home: home),
                onDeleteHome: (home) => controller.deleteHome(home.id),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomesEmptyState extends StatelessWidget {
  final VoidCallback onAddHome;

  const _HomesEmptyState({required this.onAddHome});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(
          mobile: AppSpacing.paddingMobile,
          desktop: AppSpacing.paddingDesktop,
        ),
        vertical: AppSpacing.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: EmptyHomesView(onAddHome: onAddHome),
        ),
      ),
    );
  }
}

class _HomesGrid extends StatelessWidget {
  final List<HomeModel> homes;
  final VoidCallback onAddHome;
  final ValueChanged<HomeModel> onOpenHome;
  final ValueChanged<HomeModel> onEditHome;
  final ValueChanged<HomeModel> onDeleteHome;

  const _HomesGrid({
    required this.homes,
    required this.onAddHome,
    required this.onOpenHome,
    required this.onEditHome,
    required this.onDeleteHome,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive<double>(
      mobile: AppSpacing.paddingMobile,
      desktop: AppSpacing.paddingDesktop,
    );
    final crossAxisCount = context.responsive<int>(mobile: 1, desktop: 3);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: AppSpacing.xxl,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            mainAxisExtent: 230,
          ),
          itemCount: homes.length + 1,
          itemBuilder: (context, index) {
            if (index == homes.length) {
              return AddPlaceholderCard(
                label: 'Add Home',
                icon: LucideIcons.plus,
                onTap: onAddHome,
              );
            }
            final home = homes[index];
            return HomeCard(
              home: home,
              onTap: () => onOpenHome(home),
              onEdit: () => onEditHome(home),
              onDelete: () => onDeleteHome(home),
            );
          },
        ),
      ),
    );
  }
}
