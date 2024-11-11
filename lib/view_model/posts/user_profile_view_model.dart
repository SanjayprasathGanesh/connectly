import 'package:connectly/database/database_connection.dart';
import 'package:get/get.dart';
import 'package:connectly/model/posts/posts_model.dart';

import '../../controller/local_login_storage.dart';

class UserProfileViewModel extends GetxController {
  var posts = <Posts>[].obs;
  var isLoading = false.obs;

  final LocalLoginStorage credentials = Get.find<LocalLoginStorage>();
  DatabaseConnection databaseConnection = DatabaseConnection();

  Future<void> loadPostsForUser() async {
    String userId = await credentials.getUserName() ?? '';
    isLoading.value = true;
    posts.value = await databaseConnection.getAllPostsByUserId(userId);
  }
}
