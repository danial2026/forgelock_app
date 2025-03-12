import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgelock/src/bloc/generate_password/generate_password_get_bloc.dart';
import 'package:forgelock/src/utils/router_utils.dart';
import 'package:forgelock/src/view/page/home/home_page.dart';
import 'package:forgelock/src/view/page/setting/privacy_policy_page.dart';
import 'package:forgelock/src/view/page/setting/setting_page.dart';
import 'package:forgelock/src/view/page/setting/terms_page.dart';
import 'package:go_router/go_router.dart';
import 'package:forgelock/src/app_preferences/app_preferences_controller.dart';
import 'package:forgelock/src/view/common/custom_material_page.dart';
import 'package:forgelock/src/view/page/error/something_went_wrong_page.dart';
import 'package:forgelock/src/view/page/splash_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

mixin BaseRouteHandler {
  static GoRouter routeConfig({required AppPreferencesController appPreferencesController}) {
    return GoRouter(
      observers: [],
      navigatorKey: _rootNavigatorKey,
      initialLocation: SplashPage.routeName,
      restorationScopeId: 'router',
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        GoRoute(
          path: SplashPage.routeName,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPageBuilder(
              key: state.pageKey,
              child: SplashPage(appPreferencesController: appPreferencesController),
            );
          },
        ),
        GoRoute(
          path: HomePage.routeName,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPageBuilder(
              key: state.pageKey,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => PasswordGeneratorBloc()),
                ],
                child: HomePage(
                  appPreferencesController: appPreferencesController,
                ),
              ),
            );
          },
        ),
        GoRoute(
            path: SettingPage.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPageBuilder(
                key: state.pageKey,
                child: SettingPage(appPreferencesController: appPreferencesController),
              );
            },
            routes: [
              GoRoute(
                path: RouterUtils.removeSlash(TermsPage.routeName),
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return CustomTransitionPageBuilder(
                    key: state.pageKey,
                    child: TermsPage(appPreferencesController: appPreferencesController),
                  );
                },
              ),
              GoRoute(
                path: RouterUtils.removeSlash(PrivacyPolicyPage.routeName),
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return CustomTransitionPageBuilder(
                    key: state.pageKey,
                    child: PrivacyPolicyPage(appPreferencesController: appPreferencesController),
                  );
                },
              ),
            ]),
        GoRoute(
          path: SomethingWentWrongPage.routeName,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPageBuilder(
              key: state.pageKey,
              child: const SomethingWentWrongPage(),
            );
          },
        ),
      ],
      redirect: _guard,
      onException: _onException,
    );
  }

  static Future<String?> _guard(BuildContext context, GoRouterState state) async {
    // final bool signedIn = await checkUserStatus();
    // final bool signingInFlow = state.matchedLocation == LoginPage.routeName;

    // /*
    // no need to be logged in to use to app for now
    //   // Go to /login if the user is not signed in
    //   if (!signedIn && !signingInFlow) {
    //     return LoginPage.routeName;
    //   }
    // */

    // // Go to /explore if the user is signed in and tries to go to /signin.
    // if (signedIn && signingInFlow) {
    //   return ExplorePage.routeName;
    // }

    // no redirect
    return null;
  }

  static void _onException(BuildContext context, GoRouterState state, GoRouter router) {
    router.go(SomethingWentWrongPage.routeName);
  }
}
