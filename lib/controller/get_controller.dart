import 'package:connectly/auto_routes/auth_provider.dart';
import 'package:connectly/controller/image_controller.dart';
import 'package:connectly/controller/local_login_storage.dart';
import 'package:connectly/view_model/login_page_view_model.dart';
import 'package:connectly/view_model/posts/chats_view_model.dart';
import 'package:connectly/view_model/posts/likes_view_model.dart';
import 'package:connectly/view_model/posts/post_view_model.dart';
import 'package:connectly/view_model/posts/share_posts_view_model.dart';
import 'package:get/get.dart';

import '../view_model/posts/user_profile_view_model.dart';

class GetController{
  void setControllers(){
    Get.put(AuthProvider());
    Get.put(ImageController());
    Get.put(LocalLoginStorage());
    Get.put(LoginPageViewModel());
    Get.put(SharePostsViewModel());
    Get.put(PostViewModel());
    Get.put(LikesViewModel());
    Get.put(ChatListViewModel());
    Get.put(UserProfileViewModel());
  }
}