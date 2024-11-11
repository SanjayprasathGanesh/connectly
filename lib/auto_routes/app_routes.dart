import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/auth_guard.dart';

import 'app_routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MyLoginRoute.page, initial: true),
    AutoRoute(page: MySignupRoute.page, ),
    AutoRoute(page: MyChats.page,  guards: [AuthGuard()]),
    AutoRoute(page: MyHomeRoute.page, ),
    AutoRoute(page: MyLikes.page,  guards: [AuthGuard()]),
    AutoRoute(page: MyProfile.page,  guards: [AuthGuard()]),
    AutoRoute(page: MainRoute.page,guards: [AuthGuard()],),
    AutoRoute(page: AddNewPost.page, guards: [AuthGuard()]),
    AutoRoute(page: ChatRoute.page, guards: [AuthGuard()]),
  ];
}
