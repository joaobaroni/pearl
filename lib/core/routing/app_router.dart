import 'package:go_router/go_router.dart';

import '../../presentation/views/home_detail/home_detail_page.dart';
import '../../presentation/views/homes_list/homes_list_page.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: '/homes',
  routes: [
    GoRoute(
      path: '/homes',
      name: RouteNames.homes,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const HomesListPage(),
      ),
      routes: [
        GoRoute(
          path: ':id',
          name: RouteNames.homeDetail,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: HomeDetailPage(homeId: id),
            );
          },
        ),
      ],
    ),
  ],
);
