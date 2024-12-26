import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../auth/screen/auth_screen.dart';
import '../profile/screen/profile_screen.dart';
import '../raiting/ranking_screen.dart';
import '../auth/screen/sign_up_screen.dart';
import '../profile/screen/edit_profile_screen.dart';
import '../auth/cubit/auth_cubit.dart';
import '../profile/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoriz/game1/home_view.dart';
import '../game2/game_screen.dart';
import '../game2/game_view.dart';
import '../auth/screen/loading_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(),
        child: const AuthScreen(),
      ),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(),
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ProfileCubit()..loadProfile(),
          child: const ProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        return HomeView(key: UniqueKey());
      },
    ),
    GoRoute(
      path: '/start',
      builder: (context, state) => StartScreen(),
    ),
    GoRoute(
      path: '/game-two',
      builder: (context, state) {
        return GameView(key: UniqueKey());
      },
    ),
    GoRoute(
      path: '/ranking',
      builder: (context, state) => RankingScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
