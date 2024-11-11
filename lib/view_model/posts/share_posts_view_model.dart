import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/database/database_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/posts/posts_model.dart';
import '../../model/user/user_model.dart';

class SharePostsViewModel extends GetxController{
  RxList availableUserList = [].obs;
  RxList availableUserIdsList = [].obs;
  RxBool isUsersLisLoaded = false.obs;
  RxList selectedUsersList = [].obs;

  TextEditingController message = TextEditingController();

  DatabaseConnection databaseConnection = DatabaseConnection();

  Future<void> loadAllAvailableUsers() async{
    QuerySnapshot querySnapshot = await databaseConnection.getAllUsers();
    List<User> usersList = [];
    List<String> userIdsList = [];
    User user;
    Map<String, dynamic> json = {};
    String docId = "";
    for(int i = 0;i < querySnapshot.size;i++){
      json = querySnapshot.docs[i].data() as Map<String, dynamic>;
      docId = querySnapshot.docs[i].id;
      user = User.fromJson(json);
      usersList.add(user);
      userIdsList.add(docId);
    }

    isUsersLisLoaded.value = true;
    availableUserList.value = usersList;
    availableUserIdsList.value = userIdsList;
  }

  sendPostMessage(String userId, List targetUserIdList, Posts post) async {
    for (String targetUserId in targetUserIdList) {
      String chatId = '$userId - $targetUserId';
      databaseConnection.sendPostMessage(chatId, post);
    }
    Logger().i("Post shared successfully for many users");
  }


}