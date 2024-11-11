import 'package:connectly/database/database_connection.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/chats/message_model.dart';
import '../../model/posts/posts_model.dart';
import '../../model/user/user_model.dart';

class ChatListViewModel extends GetxController {
  final DatabaseConnection _databaseService = DatabaseConnection();
  var usersList = <User>[].obs;
  var messagesList = <Messages>[].obs;

  Future<void> fetchUsers() async {
    usersList.value = await _databaseService.fetchUsers();
  }

  Future<void> fetchMessages(String chatId) async {
    Logger().i("Chat is: $chatId");
    messagesList.value = await _databaseService.fetchMessages(chatId);
    Logger().i("msg list : ${messagesList.length}");
  }

  Future<void> sendMessage(String chatId, Messages message) async {
    await _databaseService.sendTextMessages(chatId, message);
    await _databaseService.fetchMessages(chatId);
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectly/database/database_connection.dart';
// import 'package:connectly/model/chats/message_model.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
//
// import '../../model/user/user_model.dart';
//
// class ChatListViewModel extends GetxController{
//   RxList chatsList = [].obs;
//   DatabaseConnection databaseConnection = DatabaseConnection();
//
//   getChatsListByUserId() async{
//     //add user name here
//     String userId = "";
//     QuerySnapshot querySnapshot1 = await databaseConnection.getAllChats();
//     Logger().i("${querySnapshot1.size}");
//     List<Map<String, String>> chatsListMap = [];
//     Messages messages;
//       for(int j = 0;j < querySnapshot1.size;j++){
//         String chatId = querySnapshot1.docs[j].id;
//         Logger().i("CHAT ID : ${chatId}");
//         Map<String, dynamic> json = querySnapshot1.docs[j].data() as Map<String, dynamic>;
//         messages = Messages.fromJson(json);
//         if(chatId.contains(userId)){
//           chatsListMap.add({messages.targetUserId! : chatId});
//         }
//       }
//       chatsList.value = chatsListMap;
//       Logger().i("Loaded chat list : ${chatsList.length}");
//   }
// }