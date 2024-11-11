// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:connectly/view/pages/chat_page.dart' as _i2;
import 'package:connectly/view/pages/home_page.dart' as _i5;
import 'package:connectly/view/pages/login_page.dart' as _i7;
import 'package:connectly/view/pages/main_screen.dart' as _i3;
import 'package:connectly/view/pages/my_chats.dart' as _i4;
import 'package:connectly/view/pages/my_likes.dart' as _i6;
import 'package:connectly/view/pages/my_profile.dart' as _i8;
import 'package:connectly/view/pages/posts/add_new_post.dart' as _i1;
import 'package:connectly/view/pages/signup_page.dart' as _i9;
import 'package:flutter/material.dart' as _i11;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    AddNewPost.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AddNewPost(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ChatPage(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    MainRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MainScreen(),
      );
    },
    MyChats.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MyChats(),
      );
    },
    MyHomeRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MyHomePage(),
      );
    },
    MyLikes.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MyLikes(),
      );
    },
    MyLoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.MyLoginPage(),
      );
    },
    MyProfile.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MyProfile(),
      );
    },
    MySignupRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MySignupPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddNewPost]
class AddNewPost extends _i10.PageRouteInfo<void> {
  const AddNewPost({List<_i10.PageRouteInfo>? children})
      : super(
          AddNewPost.name,
          initialChildren: children,
        );

  static const String name = 'AddNewPost';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ChatPage]
class ChatRoute extends _i10.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i11.Key? key,
    required String userId,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const _i10.PageInfo<ChatRouteArgs> page =
      _i10.PageInfo<ChatRouteArgs>(name);
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.userId,
  });

  final _i11.Key? key;

  final String userId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i10.PageRouteInfo<void> {
  const MainRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MyChats]
class MyChats extends _i10.PageRouteInfo<void> {
  const MyChats({List<_i10.PageRouteInfo>? children})
      : super(
          MyChats.name,
          initialChildren: children,
        );

  static const String name = 'MyChats';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MyHomePage]
class MyHomeRoute extends _i10.PageRouteInfo<void> {
  const MyHomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MyHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyHomeRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MyLikes]
class MyLikes extends _i10.PageRouteInfo<void> {
  const MyLikes({List<_i10.PageRouteInfo>? children})
      : super(
          MyLikes.name,
          initialChildren: children,
        );

  static const String name = 'MyLikes';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.MyLoginPage]
class MyLoginRoute extends _i10.PageRouteInfo<void> {
  const MyLoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MyLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyLoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MyProfile]
class MyProfile extends _i10.PageRouteInfo<void> {
  const MyProfile({List<_i10.PageRouteInfo>? children})
      : super(
          MyProfile.name,
          initialChildren: children,
        );

  static const String name = 'MyProfile';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MySignupPage]
class MySignupRoute extends _i10.PageRouteInfo<void> {
  const MySignupRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MySignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'MySignupRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
