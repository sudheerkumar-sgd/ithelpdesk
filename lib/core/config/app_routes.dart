import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ithelpdesk/presentation/base/page_widget_provider.dart';
import 'package:ithelpdesk/presentation/home/user_main_screen.dart';
import 'package:ithelpdesk/presentation/profile/profile_screen.dart';
import 'package:ithelpdesk/presentation/profile/profile_screen_widget.dart';
import 'package:ithelpdesk/presentation/profile/rating_screen_widget.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';

class AppRoutes {
  static String initialRoute = '/';
  static String startRoute = '/start';
  static String loginRoute = '/login';
  static String guestMainRoute = '/guestMain';
  static String userMainRoute = '/dashboard';
  static String homeRoute = '/home';
  static String tourRoute = '/tour';
  static String profileRoute = '/profile';
  static String ticketRoute = '/ticket/:id';
  static String ratingRoute = '/rating/:id';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const UserMainScreen(),
      AppRoutes.userMainRoute: (context) => const UserMainScreen(),
      AppRoutes.profileRoute: (context) => ProfileScreen(),
    };
  }

  static GoRouter getAppRoutes() {
    return GoRouter(navigatorKey: GlobalKey<NavigatorState>(), routes: [
      GoRoute(
        path: AppRoutes.initialRoute,
        builder: (context, state) => const UserMainScreen(),
      ),
      GoRoute(
        path: AppRoutes.userMainRoute,
        builder: (context, state) => const UserMainScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileRoute,
        name: 'userprofile',
        builder: (context, state) {
          return PageWidgetProvider(ProfileScreenWidget());
        },
      ),
      GoRoute(
        path: '${AppRoutes.profileRoute}/:username',
        name: 'profile',
        builder: (context, state) {
          final username = state.pathParameters['username'];
          return PageWidgetProvider(ProfileScreenWidget(
            userName: username,
          ));
        },
      ),
      GoRoute(
        path: AppRoutes.ticketRoute,
        name: 'ticket',
        builder: (context, state) {
          final ticketId = state.pathParameters['id'];
          return PageWidgetProvider(ViewRequest(
            ticketId: ticketId,
          ));
        },
      ),
      GoRoute(
        path: '/viewRequest',
        pageBuilder: (context, state) {
          final extra = state.extra as Map;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ViewRequest(
              ticketDetails: extra['ticketDetails'],
              isMyTicket: extra['isMyTicket'],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.ratingRoute,
        name: 'Rating',
        builder: (context, state) {
          final ticketId = state.pathParameters['id'];
          return PageWidgetProvider(RatingScreenWidget(
            ticketID: ticketId ?? '',
          ));
        },
      ),
    ]);
  }
}
