import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Home')),
      ),
    ),
  ],
);
