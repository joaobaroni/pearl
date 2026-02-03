import 'package:go_router/go_router.dart';

import '../../presentation/views/home_detail/home_detail_view.dart';
import '../../presentation/views/home/home_view.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: '/homes',
  routes: [
    GoRoute(
      path: '/homes',
      name: RouteNames.homes,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const HomeView(),
      ),
      routes: [
        GoRoute(
          path: ':id',
          name: RouteNames.homeDetail,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: HomeDetailView(homeId: id),
            );
          },
        ),
      ],
    ),
  ],
);
