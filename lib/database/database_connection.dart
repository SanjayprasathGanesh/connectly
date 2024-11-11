import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../model/chats/message_model.dart';
import '../model/posts/posts_model.dart';
import '../model/user/user_model.dart';

class DatabaseConnection{
  //Firebase queries related to handling the posts collection.
  Future<void> addNewPost(Posts post)async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc()
        .set(post.toJson());
  }

  Future<QuerySnapshot> getAllPosts() async{
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("postedDate", descending: true)
        .get();
  }

  // Future<QuerySnapshot> getPostsByUserId(String userId) async{
  //   return FirebaseFirestore.instance
  //       .collection("posts")
  //       .where("userId", isEqualTo: userId)
  //       .orderBy("postedDate", descending: true)
  //       .get();
  // }

  Future<void> updatePost(String postId, Posts post)async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .update(post.toJson());
  }

  Future<void> deletePost(String postId)async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete();
  }

  Future<List<Posts>> getAllPostsByUserId(String userId) async{
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Posts.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Logger().e('Error fetching posts: $e');
    }
    return [];
  }

  //Firebase queries related to handling  related to sharing message/post.
  Future<void> sendPostMessage(String chatId, Posts post) async{
    try{
      Messages messages= Messages(
          fromUserId: chatId.split("-")[0],
          targetUserId: chatId.split("-")[1],
          postMap: post.toJson(),
          message: "",
          sentTime: DateTime.now().toString()
      );
      return await FirebaseFirestore
          .instance
          .collection("chats")
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(messages.toJson());
    } catch(e){
      Logger().e("Error occurred while saving message: $e");
      if (e is FirebaseException) {
        Logger().e("Firebase Exception: ${e.message}");
      } else {
        Logger().e("General Exception: $e");
      }
    }
  }

  Future<List<QuerySnapshot>> getAllChatsWithMessages() async {
    List<QuerySnapshot> chatMessagesSnapshots = [];
    try {
      QuerySnapshot chatSnapshots = await FirebaseFirestore.instance.collection('chats').get();
      for (var chatDoc in chatSnapshots.docs) {
        String chatId = chatDoc.id;
        QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection(chatId)
            .get();
        chatMessagesSnapshots.add(messagesSnapshot);
      }
    } catch (e) {
      Logger().e("Error getting all chats with messages: $e");
    }
    return chatMessagesSnapshots;
  }

  Stream<QuerySnapshot> getSpecificChat(String groupChatId) {
    return FirebaseFirestore
        .instance
        .collection('chats')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  // method to Fetch messages between two users
  Future<List<Messages>> fetchMessages(String chatId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection(chatId)
          .orderBy('sentTime', descending: true)
          .get();

      Logger().i("snap ${snapshot.size}");
      return snapshot.docs
          .map((doc) => Messages.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

    } catch (e) {
      Logger().e("Error fetching messages: $e");
      return [];
    }
  }

  // method to Send a new message only.
  Future<void> sendTextMessages(String chatId, Messages message) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(message.toJson());
    } catch (e) {
      Logger().e("Error sending message: $e");
    }
  }

  //Firebase queries related to handling the users collections.
  Future<QuerySnapshot> getAllUsers() async{
    return FirebaseFirestore.instance.collection("users").get();
  }

  Future<List<User>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.map((doc) => User.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      Logger().e("Error fetching users: $e");
      return [];
    }
  }

  Future<bool> checkUserExist(String userId) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();

    if(querySnapshot.size == 1){
      return true;
    }
    return false;
  }

  Future<bool> validateUserLogin(String uName, String psw) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userId', isEqualTo: uName)
        .where('userPsw', isEqualTo: psw)
        .get();

    if(querySnapshot.size == 1){
      return true;
    }
    return false;
  }

  Future<void> addNewUser(User users) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc()
        .set(users.toJson());
  }

  Future<void> deleteUser(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();
    String userDocId = querySnapshot.docs[0].id;
    return FirebaseFirestore.instance.collection('users').doc(userDocId).delete();
  }

//This method is used to upload the image/video to firebase storage
//but unfortunately firebase is asking to get paid to access Firebase storage.
// Future<String> uploadFile(File file) async {
//   try {
//     String fileName = '${DateTime.now().millisecondsSinceEpoch}-${file.uri.pathSegments.last}';
//     Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
//     UploadTask uploadTask = storageRef.putFile(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   } catch (e) {
//     print("Error uploading file: $e");
//     return '';
//   }
// }

// Future<String> uploadFiles(dynamic file) async {
//   try {
//     String fileName = '${DateTime.now().millisecondsSinceEpoch}-${file is File ? file.uri.pathSegments.last : 'web-file'}';
//     Reference storageRef = FirebaseStorage.instance.ref().child('$fileName');
//
//     // Check if running on the web
//     if (kIsWeb) {
//       UploadTask uploadTask = storageRef.putData(await file.readAsBytes());
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       Logger().i("Image uploaded to storage : $downloadUrl");
//       return downloadUrl;
//     } else {
//       UploadTask uploadTask = storageRef.putFile(file as File);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       Logger().i("Image uploaded to storage : $downloadUrl");
//       return downloadUrl;
//     }
//   } catch (e) {
//     print("Error uploading file: $e");
//     return '';
//   }
// }

// Future<String> uploadFiles(dynamic file) async {
//   try {
//     if (file == null) {
//       throw Exception("File is null");
//     }
//
//     String fileName = '${DateTime.now().millisecondsSinceEpoch}-${file is File ? file.uri.pathSegments.last : 'web-file'}';
//     String sanitizedFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9-_]'), '_');
//     Reference storageRef = FirebaseStorage.instance.ref().child(sanitizedFileName);
//
//     if (kIsWeb) {
//       final bytes = await (file).readAsBytes();
//       UploadTask uploadTask = storageRef.putData(bytes);
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         Logger().i("Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}");
//       });
//
//       // Get the download URL after upload
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       Logger().i("Image uploaded to storage: $downloadUrl");
//
//       return downloadUrl;
//     } else {
//       if (file is! File) {
//         throw Exception("Expected a File but received something else.");
//       }
//
//       UploadTask uploadTask = storageRef.putFile(file);
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         Logger().i("Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}");
//       });
//
//       // Get the download URL after upload
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       Logger().i("Image uploaded to storage: $downloadUrl");
//
//       return downloadUrl;
//     }
//   } catch (e) {
//     Logger().e("Error uploading file: $e");
//     return '';
//   }
// }

// Future<List<String>> uploadImageFiles(List<File> filesList) async {
//   List<String> downloadUrls = [];
//   try {
//     for (File file in filesList) {
//       String fileName = '${DateTime.now().millisecondsSinceEpoch}-${file.uri.pathSegments.last}';
//       Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
//       UploadTask uploadTask = storageRef.putFile(file);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       downloadUrls.add(downloadUrl);
//     }
//     return downloadUrls;
//   } catch (e) {
//     print("Error uploading files: $e");
//     return [];
//   }
// }

}