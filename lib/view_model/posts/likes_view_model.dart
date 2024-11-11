import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/database/database_connection.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controller/local_login_storage.dart';
import '../../model/posts/posts_model.dart';

class LikesViewModel extends GetxController{
  RxList likedPostsLists = [].obs;
  RxList likedPostsIdsList = [].obs;
  RxBool isAllPostsLoaded = false.obs;

  DatabaseConnection databaseConnection = DatabaseConnection();
  final LocalLoginStorage credentials = Get.find<LocalLoginStorage>();

  Future<void> getMyLikedPostsAlone() async{
    try {
      QuerySnapshot querySnapshot = await databaseConnection.getAllPosts();
      String userId = await credentials.getUserName() ?? '';
      List<Posts> userLikedPostsList = [];
      List<String> userLikedPostsIdsList = [];
      Posts posts;
      Map<String, dynamic> json = {};
      String id = "";

      for (int i = 0; i < querySnapshot.size; i++) {
        json = querySnapshot.docs[i].data() as Map<String, dynamic>;
        id = querySnapshot.docs[i].id;
        posts = Posts.fromJson(json);

        if (posts.likedByList!.contains(userId)) {
          userLikedPostsList.add(posts);
          userLikedPostsIdsList.add(id);
        }
      }

      likedPostsLists.value = userLikedPostsList;
      likedPostsIdsList.value = userLikedPostsIdsList;
      isAllPostsLoaded.value = true;
      likedPostsLists.refresh();
      update();

    } catch (e) {
      Logger().e("Error fetching liked posts: $e");
      isAllPostsLoaded.value = false;
    }
  }
}