import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/app_routes.gr.dart';
import 'package:connectly/auto_routes/auth_provider.dart';
import 'package:get/get.dart';

class AuthGuard extends AutoRouteGuard{
  final AuthProvider authProvider = Get.find<AuthProvider>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if(authProvider.getIsLoggedIn){
      resolver.next(true);
    } else{
      resolver.redirect(const MyLoginRoute());
    }
  }
}