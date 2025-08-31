import 'package:flutter_application/screens/Auth/PrivateLogin.dart';
import 'package:flutter_application/screens/Auth/login_page.dart';
import 'package:flutter_application/screens/Auth/public_login.dart';
import 'package:flutter_application/screens/science/science.dart';
import 'package:flutter_application/screens/streams/streams.dart';
import 'package:flutter_application/screens/subject/maths.dart';
import 'package:flutter_application/screens/subject/topic/algebra.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/register/',
  routes: [
    GoRoute(
      path: '/login/public',
      name: 'public-login',
      builder: (context, state) => const PublicLoginPage(),
    ),
    GoRoute(
      path: '/login/private',
      name: 'private-login',
      builder: (context, state) => const PrivateLoginPage(),
    ),
    GoRoute(
      path: '/streams',
      name: 'streams',
      builder: (context, state) => const StreamSelectionPage(),
    ),
    GoRoute(
      path: '/science',
      name: 'science',
      builder: (_, __) => const ScienceSubjectsPage(),
    ),
    GoRoute(
      path: '/subject/maths',
      name: 'maths',
      builder: (_, __) => const MathsPage(),
    ),
    GoRoute(
      path: '/subject/maths/topic/algebra-equations-inequalities',
      name: 'maths-algebra',
      builder: (_, __) => const AlgebraHubPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
      name: 'register',
    ),
  ],
);
